$bytes = [System.IO.File]::ReadAllBytes("C:\Users\Rodrigo\Desktop\Mestrado\2Semestre\Auditoria\Trabalho-Auditoria-AnaliseForense\Prova2\Documents\notes.txt")

function Find-Pattern {
    param(
        [byte[]]$Data,
        [byte[]]$Pattern,
        [string]$Name
    )

    for ($i = 0; $i -le $Data.Length - $Pattern.Length; $i++) {
        $found = $true

        for ($j = 0; $j -lt $Pattern.Length; $j++) {
            if ($Data[$i + $j] -ne $Pattern[$j]) {
                $found = $false
                break
            }
        }

        if ($found) {
            "{0} encontrado em offset decimal {1} / hex 0x{2:X}" -f $Name, $i, $i
        }
    }
}

Find-Pattern $bytes ([byte[]](0xFF,0xD8,0xFF)) "JPEG"
Find-Pattern $bytes ([byte[]](0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A)) "PNG"
Find-Pattern $bytes ([byte[]](0x50,0x4B,0x03,0x04)) "ZIP/DOCX"
Find-Pattern $bytes ([byte[]](0x25,0x50,0x44,0x46)) "PDF"