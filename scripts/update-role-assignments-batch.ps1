param(
    [Parameter(Mandatory=$true)]
    [string]$BatchFile
)

# Read the list of files for this batch
$filesToUpdate = Get-Content $BatchFile

$oldPattern = "role-assignments-portal\.yml"
$newLink = "/azure/role-based-access-control/role-assignments-portal"

$updatedCount = 0

foreach ($filePath in $filesToUpdate) {
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw
        
        # Replace various formats of the link
        $originalContent = $content
        
        # Replace markdown links with .yml extension
        $content = $content -replace "\[([^\]]+)\]\([^)]*role-assignments-portal\.yml[^)]*\)", "[$1]($newLink)"
        
        # Replace direct references to the .yml file
        $content = $content -replace "role-assignments-portal\.yml", "role-assignments-portal"
        
        if ($content -ne $originalContent) {
            Set-Content -Path $filePath -Value $content -NoNewline
            Write-Host "Updated: $filePath"
            $updatedCount++
        }
    }
}

Write-Host "Updated $updatedCount files in batch: $BatchFile"
