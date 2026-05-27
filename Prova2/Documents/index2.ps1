$bytes = [System.IO.File]::ReadAllBytes("C:\Users\Rodrigo\Desktop\Mestrado\2Semestre\Auditoria\Trabalho-Auditoria-AnaliseForense\Prova2\Documents\notes.txt")

$start = 94
$length = $bytes.Length - $start

$out = New-Object byte[] $length
[Array]::Copy($bytes, $start, $out, 0, $length)

[System.IO.File]::WriteAllBytes("C:\Users\Rodrigo\Desktop\Mestrado\2Semestre\Auditoria\Trabalho-Auditoria-AnaliseForense\Prova2\Documents\notes_carved.jpg", $out)