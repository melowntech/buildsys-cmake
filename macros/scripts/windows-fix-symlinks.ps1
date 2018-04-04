function Is-Directory($file) {
    return [bool]($file.Attributes -band [IO.FileAttributes]::Directory)
}

Get-ChildItem -Path . -Attributes ReparsePoint | Foreach-Object {
    $srcItem = $_
    $src = $srcItem.FullName
    $target = $srcItem.Target[0]
    $dst = Resolve-Path $Target
    $dstItem = Get-Item $dst

    $srcDir = Is-Directory($srcItem)
    $dstDir = Is-Directory($dstItem)

    if ($srcDir -eq $dstDir) { return }

    Write-Host "    symlink type mismatch:" $src "["({file}, {dir})[$srcDir]"] ->" $dst "["({file}, {dir})[$dstDir]"]"

    Remove-Item -Path $src

    if ($dstDir) {
        cmd.exe /C mklink /D "$src" "$Target" > $null
    } else {
        cmd.exe /C mklink "$src" "$Target" > $null
    }
}
