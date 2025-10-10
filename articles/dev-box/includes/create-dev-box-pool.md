


The following steps show you how to create a dev box pool in a project. When creating a dev box pool, you can select a marketplace image, custom image, or dev box definition. Using images gives you the flexibility to choose the compute size and storage that best fits your needs.

> [!TIP]
> Use project policies to control the SKUs and images, or other resources such as networks that specific project teams can use. For more information, see [Control resource use with project policies in Microsoft Dev Box](../how-to-configure-project-policy.md).

If you don't have an available dev center and project, follow the steps in [Quickstart: Configure Microsoft Dev Box](../quickstart-configure-dev-box-service.md) to create them.

1. Sign in to the [Azure portal](https://portal.azure.com).

1. In the search box, enter **projects**. In the list of results, select **Projects**.

1. Open the project where you want to create the dev box pool.
  
   :::image type="content" source="../media/create-dev-box-pool/select-project.png" alt-text="Screenshot that shows the list of existing projects." lightbox="../media/create-dev-box-pool/select-project.png":::

1. Select **Dev box pools**, then select **Create**.

   :::image type="content" source="../media/create-dev-box-pool/create-pool.png" alt-text="Screenshot of an empty list of dev box pools within a project, along with selections to start creating a pool." lightbox="../media/create-dev-box-pool/create-pool.png":::

1. On the **Create a dev box pool** pane, on the **Basics** tab, enter the following values:

   | Setting | Value |
   |---|---|
   | **Display name** | Enter a name for the pool. The pool name is visible to developers to select when they're creating dev boxes. The name must be unique within a project. |
   | **Definition** | Select a marketplace image definition, custom image definition or existing dev box definition. </br>A dev box definition determines the base image and size for the dev boxes that are created. </br>An image definition allows you to specify your required Compute and SKU.  |
   | **Compute** | Image definitions only. Select the VM size for the dev boxes in this pool. |
   | **Storage** | Image definition only. Select the storage size for the dev boxes in this pool. |
   | **Hibernation** | Shows whether hibernation is supported or not. |
   | **Region** |  |
   | **Network connection** | 1. Select **Deploy to a Microsoft hosted network**. </br>2. Select your desired deployment region for the dev boxes. Choose a region close to your expected dev box users for the optimal user experience. |
   | **Licensing** | Select this checkbox to confirm that your organization has Azure Hybrid Benefit licenses that you want to apply to the dev boxes in this pool. |

   :::image type="content" source="../media/create-dev-box-pool/dev-box-image-pool-create-basics-hibernation.png" alt-text="Screenshot of the Basics pane for creating a dev box pool." lightbox="../media/create-dev-box-pool/dev-box-image-pool-create-basics-hibernation.png":::

1. On the **Management** tab, enter the following values:

   | Setting | Value |
   |---|---|
   | **Roles** | |
   | **Dev box Creator Privileges** | Select **Local Administrator** or **Standard User**. |
   | **Access** | |
   | **Enable single sign-on (SSO)** | Select to enable users to sign in to their dev boxes by using their organizational credentials. |
   | **Headless connections** | Select to enable developers to open a dev box in Visual Studio Code without a full desktop experience. |
   | **Cost controls** | |
   | **Auto-stop on schedule** | Select the checkbox to enable an autostop schedule. You can also configure an autostop schedule after the pool is created. |
   | **Stop time** | Select a time to shut down all the dev boxes in the pool. Dev boxes that support hibernation will hibernate at the specified time. Dev Boxes that don't support hibernation shut down.  |
   | **Time zone** | Select the time zone for the stop time. |
   | **Hibernate on disconnect** | Hibernates dev boxes that no one is connected to after a specified grace period. |
   | **Grace period** | Hibernates dev boxes that have never been connected to after a specified grace period. |

   :::image type="content" source="../media/create-dev-box-pool/dev-box-pool-create-management-hibernation.png" alt-text="Screenshot of the Management pane for creating a dev box pool." lightbox="../media/create-dev-box-pool/dev-box-pool-create-management-hibernation.png":::

1. Select **Create**.

1. Check that the new dev box pool appears in the list. You might need to refresh the screen.

The Azure portal deploys the dev box pool and runs health checks to make sure the image and network pass the validation criteria for dev boxes. The following screenshot shows four dev box pools, each with a different status.

:::image type="content" source="../media/create-dev-box-pool/dev-box-pool-grid-populated.png" alt-text="Screenshot that shows a list of dev box pools and status information." lightbox="../media/create-dev-box-pool/dev-box-pool-grid-populated.png":::
