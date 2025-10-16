# Master script to process all batches and create PRs

$batchFiles = Get-ChildItem -Path "batch-*-files.txt" | Sort-Object Name

foreach ($batchFile in $batchFiles) {
    $batchNumber = ($batchFile.Name -split "-")[1]
    
    Write-Host "Processing $($batchFile.Name)..."
    
    # Create a new branch for this batch
    $branchName = "update-role-assignments-batch-$batchNumber"
    git checkout main
    git pull origin main
    git checkout -b $branchName
    
    # Update files in this batch
    & ".\update-role-assignments-batch.ps1" -BatchFile $batchFile.Name
    
    # Commit changes
    git add .
    git commit -m "Update role-assignments-portal.yml links to generic links (batch $batchNumber)"
    
    # Push branch (you'll need to create PR manually or use GitHub CLI)
    git push origin $branchName
    
    Write-Host "Completed batch $batchNumber. Branch: $branchName"
    Write-Host "Create PR for this batch before proceeding to the next one."
    
    # Wait for user confirmation before proceeding
    Read-Host "Press Enter to continue to next batch or Ctrl+C to stop"
}
