---
title: Create custom artifacts for VMs
description: Learn how to create and use artifacts to deploy and set up applications on DevTest Labs virtual machines (VMs).
ms.topic: how-to
ms.author: rosemalcolm
author: RoseHJM
ms.date: 09/30/2023
ms.custom: UpdateFrequency2
---

# Create custom artifacts for DevTest Labs VMs

This article describes how to create custom artifacts that specify how to provision Azure DevTest Labs VMs. An artifact consists of an artifact definition JSON file and other script files stored in a Git repository folder. You can [add your artifact repository to your lab](add-artifact-repository.md).

You can [add artifacts to labs VMs](add-artifact-vm.md) or [specify mandatory artifacts to be added to all lab VMs](devtest-lab-mandatory-artifacts.md).

## Understand artifact definition files

An artifact definition file consists of a JSON expressions that specifies what to install on a VM. The file defines an artifact name, a command to run, and parameters available for the command. If the artifact contains other script files, you can refer to them by name in the artifact definition file.

The following example shows the basic structure of an *artifactfile.json* artifact definition file:

```json
  {
    "$schema": "https://raw.githubusercontent.com/Azure/azure-devtestlab/master/schemas/2016-11-28/dtlArtifacts.json",
    "title": "<title>",
    "description": "<description>",
    "iconUri": "",
    "targetOsType": "<os>",
    "parameters": {
      "<paramName>": {
        "type": "<type>",
        "displayName": "<display name>",
        "description": "<description>"
      }
    },
    "runCommand": {
      "commandToExecute": "<command>"
    }
  }
```

The definition has the following required and optional elements:

| Element name | Description |
| --- | --- |
| `$schema` | Location of the JSON schema file, which can help you test the validity of the definition file.|
| `title` | **Required** artifact name to display. |
| `description` | **Required** artifact description. |
| `iconUri` | Artifact icon URI to display.|
| `targetOsType` | **Required** operating system to install on. The supported values are `Windows` or `Linux`. |
| `parameters` | Available artifact customizations during installation.|
| `runCommand` | **Required** command to install the artifact on the VM. |

### Artifact parameters

The `parameters` section of the definition file defines the options and values a user can specify when they install the artifact. You can refer to these values in the `runcommand`.

The following structure defines a parameter:

```json
  "parameters": {
    "<name>": {
      "type": "<type>",
      "displayName": "<display name>",
      "description": "<description>"
    }
  }
```

Each parameter requires a name. The parameter definition requires the following elements:

| Element name | Description |
| --- | --- |
| `type` | **Required** parameter value type. The type can be any valid JSON `string`, integer `int`, boolean `bool`, or `array`. |
| `displayName` | **Required** parameter name to display to the user. |
| `description` | **Required** parameter description.|

### Secure string parameters

To include secrets in the artifact definition, declare the secrets as secure strings by using the `secureStringParam` syntax in the `parameters` section of the definition file. The `description` element allows any text string, including spaces, and presents it in the UI as masked characters.


```json

    "securestringParam": {
      "type": "securestring",
      "displayName": "Secure String Parameter",
      "description": "<any text string>",
      "allowEmpty": false
    },
```

The artifact install command to run the PowerShell script takes the secure string created by using the `ConvertTo-SecureString` command.

```json
  "runCommand": {
    "commandToExecute": "[concat('powershell.exe -ExecutionPolicy bypass \"& ./artifact.ps1 -StringParam ''', parameters('stringParam'), ''' -SecureStringParam (ConvertTo-SecureString ''', parameters('securestringParam'), ''' -AsPlainText -Force) -IntParam ', parameters('intParam'), ' -BoolParam:$', parameters('boolParam'), ' -FileContentsParam ''', parameters('fileContentsParam'), ''' -ExtraLogLines ', parameters('extraLogLines'), ' -ForceFail:$', parameters('forceFail'), '\"')]"
  }
```

Don't log secrets to the console, because the script captures output for user debugging.

### Use artifact expressions and functions

You can use expressions and functions to construct the artifact install command. Expressions evaluate when the artifact installs. Expressions can appear anywhere in a JSON string value, and always return another JSON value. Enclose expressions with brackets, `[ ]`. If you need to use a literal string that starts with a bracket, use two brackets `[[`.

You usually use expressions with functions to construct a value. Function calls are formatted as `functionName(arg1, arg2, arg3)`.

Common functions include:

| Function | Description |
| --- | --- |
|`parameters(parameterName)`|Returns a parameter value to provide when the artifact command runs.|
|`concat(arg1, arg2, arg3, ...)`|Combines multiple string values. This function can take various arguments.|

The following example uses expressions and functions to construct a value:

```json
  runCommand": {
      "commandToExecute": "[concat('powershell.exe -ExecutionPolicy bypass \"& ./startChocolatey.ps1'
  , ' -RawPackagesList ', parameters('packages')
  , ' -Username ', parameters('installUsername')
  , ' -Password ', parameters('installPassword'))]"
  }
```

## Create a custom artifact

To create a custom artifact:

- Install a JSON editor to work with artifact definition files. [Visual Studio Code](https://code.visualstudio.com/) is available for Windows, Linux, and macOS.

- Start with a sample *artifactfile.json* definition file.

  The public [DevTest Labs artifact repository](https://github.com/Azure/azure-devtestlab/tree/master/Artifacts) has a rich library of artifacts you can use. You can download an artifact definition file and customize it to create your own artifacts.

  This article uses the *artifactfile.json* definition file and *artifact.ps1* PowerShell script at [https://github.com/Azure/azure-devtestlab/tree/master/Artifacts/windows-test-paramtypes](https://github.com/Azure/azure-devtestlab/tree/master/Artifacts/windows-test-paramtypes).

- Use IntelliSense to see valid elements and value options that you can use to construct an artifact definition file. For example, when you edit the `targetOsType` element, IntelliSense shows you `Windows` or `Linux` options.

- Store your artifacts in public or private Git artifact repositories.

  - Store each *artifactfile.json* artifact definition file in a separate directory named the same as the artifact name.
  - Store the scripts that the install command references in the same directory as the artifact definition file.
      
  The following screenshot shows an example artifact folder:

  ![Screenshot that shows an example artifact folder.](./media/devtest-lab-artifact-author/git-repo.png)

- To store your custom artifacts in the public [DevTest Labs artifact repository](https://github.com/Azure/azure-devtestlab/tree/master/Artifacts), open a pull request against the repo.
- To add your private artifact repository to a lab, see [Add an artifact repository to your lab in DevTest Labs](add-artifact-repository.md).

## Next steps

- [Add artifacts to DevTest Labs VMs](add-artifact-vm.md)
- [Diagnose artifact failures in the lab](devtest-lab-troubleshoot-artifact-failure.md)
- [Troubleshoot issues when applying artifacts](devtest-lab-troubleshoot-apply-artifacts.md)
