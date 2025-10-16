# Script to find and group files containing role-assignments-portal.yml references

$articlesPath = "c:\Users\jfields\git\azure-docs-pr\articles"
$searchPattern = "role-assignments-portal\.yml"
$batchSize = 50

# Find all files containing the pattern
$files = Get-ChildItem -Path $articlesPath -Recurse -Include "*.md" | 
    Where-Object { (Get-Content $_.FullName -Raw) -match $searchPattern }

Write-Host "Found $($files.Count) files containing role-assignments-portal.yml"

# Group files into batches
$batches = for ($i = 0; $i -lt $files.Count; $i += $batchSize) {
    $files[$i..([Math]::Min($i + $batchSize - 1, $files.Count - 1))]
}

# Create batch files
for ($batchNum = 1; $batchNum -le $batches.Count; $batchNum++) {
    $batchFiles = $batches[$batchNum - 1]
    $batchFileName = Join-Path $PSScriptRoot "batch-$batchNum-files.txt"
    
    $batchFiles | ForEach-Object { $_.FullName } | Out-File -FilePath $batchFileName -Encoding UTF8
    
    Write-Host "Created batch-$batchNum-files.txt with $($batchFiles.Count) files"
}

Write-Host "Total batches created: $($batches.Count)"
Write-Host "Batch files created in: $PSScriptRoot"
