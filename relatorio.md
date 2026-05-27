# Relatório de Análise Forense Digital

**Unidade Curricular:** Auditoria e Análise Forense  
**Trabalho:** Trabalho Prático  
**Caso:** The Mirror, The Glass Prison e The Shattered Fortress  
**Autor:** Rodrigo Esteves  
**Instituição:** Universidade da Beira Interior  
**Data:** 2026-05-22  
**Versão:** 1.0  
**Estado:** Draft  
**Classificação:** Confidencial / Uso académico  

---

## Controlo de versões

| Versão | Data | Autor | Estado | Alterações |
|---|---|---|---|---|
| 1.0 | 2026-05-22 | Rodrigo Esteves | Draft | Redação inicial da Prova I |

---

## Sumário executivo

Este relatório documenta a análise forense realizada no âmbito do trabalho prático da unidade curricular de Auditoria e Análise Forense. A investigação incide sobre três ambientes distintos: Windows, Linux e Android, representados respetivamente por *The Mirror*, *The Glass Prison* e *The Shattered Fortress*.

Nesta fase foi analisado o ambiente Windows, correspondente à Prova I do desafio *The Mirror*. O objetivo consistia em identificar uma ferramenta mascarada e determinar o momento exato em que esta foi ativada, de forma a obter uma chave no formato `AAAAMMDD HHMM`.

A análise iniciou-se com a preservação da imagem original e criação de uma cópia de trabalho. Foram depois exportados artefactos relevantes através do FTK Imager, nomeadamente hives do Registo do Windows, ficheiros Prefetch, logs e ficheiros do perfil do utilizador `d3vucci`.

Inicialmente foi identificado o executável `svcutl32.exe`, presente em artefactos como `UserAssist`, `RunMRU` e Prefetch. No entanto, a chave derivada do seu timestamp não permitiu abrir a arca `chest.7z`, pelo que esta hipótese foi descartada como resposta final da Prova I.

A análise foi então alargada a outros executáveis registados no perfil do utilizador. Foi identificado o ficheiro `chest_stage1.exe`, localizado em `C:\Users\d3vucci\Desktop\chest_stage1.exe`. Este executável foi encontrado no `UserAssist` e confirmado através do ficheiro Prefetch `CHEST_STAGE1.EXE-870BD780.pf`.

O timestamp relevante identificado foi `2026-05-01 12:09:03`, o que permitiu obter a chave `20260501 1209`. Esta chave foi validada com sucesso através da abertura do ficheiro `chest.7z`.

---

## 1. Âmbito e objetivos

O presente relatório documenta a análise forense realizada no âmbito do trabalho prático da unidade curricular de Auditoria e Análise Forense.

A investigação incide sobre três ambientes:

- *The Mirror* — Windows;
- *The Glass Prison* — Linux;
- *The Shattered Fortress* — Android.

O objetivo global do trabalho é recuperar cinco provas digitais, reconstruir os acontecimentos relevantes e identificar o atacante com base nas evidências encontradas.

Nesta fase do relatório é documentada a análise da **Prova I**, relativa ao ambiente Windows, identificado no enunciado como *The Mirror*. O objetivo específico desta prova era identificar uma ferramenta mascarada no sistema Windows e determinar o momento exato em que esta foi ativada.

A chave da Prova I deveria ser obtida no formato:

`AAAAMMDD HHMM`

---

## 2. Autorização e contexto da investigação

A análise foi realizada em contexto académico, no âmbito da unidade curricular de Auditoria e Análise Forense.

Foram utilizados exclusivamente os ficheiros e imagens disponibilizados para o trabalho prático. Não foram analisados sistemas reais nem dados externos ao desafio.

A investigação foi conduzida em ambiente controlado, com o objetivo de aplicar técnicas de análise forense digital, preservação de evidências, extração de artefactos, análise de Registo do Windows, análise de Prefetch e documentação técnica dos resultados.

---

## 3. Metodologia geral

A metodologia seguida teve como objetivo garantir a preservação da evidência, a reprodutibilidade da análise e a documentação dos passos realizados.

Foram seguidas as seguintes fases:

1. Preservação da imagem original;
2. Criação de uma cópia de trabalho;
3. Verificação de integridade através de hashes;
4. Abertura da imagem no FTK Imager;
5. Identificação da partição principal do sistema Windows;
6. Exportação dos artefactos relevantes;
7. Análise do Registo do utilizador `d3vucci`;
8. Análise dos ficheiros Prefetch;
9. Validação da chave através da abertura da arca `chest.7z`;
10. Documentação das evidências e conclusões.

---

## 4. Inventário de evidências

| ID | Evidência | Tipo | Origem / Localização | Hash / Integridade | Estado |
|---|---|---|---|---|---|
| EV-001 | `The Mirror Single.E01` | Imagem forense | Ficheiro original fornecido no desafio | SHA-256: `F4A10ED08E1C6AB687E56854A6907866FBC472AA3E3F643CA89BA8462FCCC619` | Original preservado |
| EV-002 | `The Mirror Single Copy.E01` | Cópia de trabalho | Pasta `copia` | SHA-256: `F4A10ED08E1C6AB687E56854A6907866FBC472AA3E3F643CA89BA8462FCCC619` | Utilizada para análise |
| EV-003 | `NTUSER.DAT` | Hive do Registo | `Users\d3vucci\NTUSER.DAT` | Exportado via FTK Imager | Analisado no Registry Explorer |
| EV-004 | `UsrClass.dat` | Hive do Registo | `Users\d3vucci\AppData\Local\Microsoft\Windows\UsrClass.dat` | Exportado via FTK Imager | Exportado para análise complementar |
| EV-005 | Hives do sistema | Registo do Windows | `Windows\System32\config` | Exportado via FTK Imager | Exportado para análise complementar |
| EV-006 | Pasta `Prefetch` | Artefactos de execução | `Windows\Prefetch` | Exportado via FTK Imager | Analisado com PECmd |
| EV-007 | `chest.7z` | Arquivo protegido | `Users\d3vucci\Desktop\chest.7z` | Exportado via FTK Imager | Validado com 7-Zip |
| EV-008 | `backup_old.7z` | Arquivo comprimido | `Users\d3vucci\Desktop\backup_old.7z` | Exportado via FTK Imager | Exportado para análise complementar |
| EV-009 | `The Miracle and the Sleeper.txt` | Ficheiro de texto / entrada apagada | `Users\d3vucci\Desktop` | Entrada identificada no FTK Imager | Relevante para fase seguinte |

---

## 5. Cadeia de custódia

| Data/Hora | Evidência | Ação | Ferramenta / Método | Responsável | Resultado |
|---|---|---|---|---|---|
| 2026-05-22 | EV-001 — `The Mirror Single.E01` | Receção/download da imagem | Ficheiro fornecido no desafio | Rodrigo Esteves | Evidência original armazenada na pasta `original` |
| 2026-05-22 | EV-001 / EV-002 | Criação de cópia de trabalho | Cópia local do ficheiro | Rodrigo Esteves | Criada a cópia `The Mirror Single Copy.E01` |
| 2026-05-22 | EV-001 / EV-002 | Verificação de integridade | PowerShell `Get-FileHash` | Rodrigo Esteves | Hash SHA-256 coincidente |
| 2026-05-22 | EV-002 | Abertura da imagem | FTK Imager 8.2.0.33 SP1 | Rodrigo Esteves | Imagem aberta para análise |
| 2026-05-22 | EV-003 a EV-009 | Exportação de artefactos | FTK Imager 8.2.0.33 SP1 | Rodrigo Esteves | Artefactos exportados para análise |
| 2026-05-22 | EV-006 | Parsing dos ficheiros Prefetch | PECmd 2026.5.0 | Rodrigo Esteves | Resultados exportados para CSV |
| 2026-05-22 | EV-007 | Validação da chave | 7-Zip 26.01 | Rodrigo Esteves | `chest.7z` aberto com sucesso |

---

## 6. Ferramentas utilizadas

| Ferramenta | Versão | Finalidade |
|---|---:|---|
| FTK Imager | 8.2.0.33 SP1 | Abertura da imagem forense, verificação de hashes e exportação de artefactos |
| Registry Explorer | 2026.5.0 | Análise dos hives do Registo do Windows, incluindo `NTUSER.DAT` |
| PECmd | 2026.5.0 | Parsing dos ficheiros Prefetch e exportação dos resultados para CSV |
| 7-Zip | 26.01 | Validação da chave e extração do ficheiro `chest.7z` |
| PowerShell | Windows PowerShell | Cálculo de hashes e execução de comandos auxiliares |

---

# 7. Prova I — O Espelho

## 7.1 Objetivo da Prova I

A primeira missão do desafio *The Mirror* tinha como objetivo identificar uma ferramenta mascarada no sistema Windows e determinar o momento exato em que esta foi ativada.

Segundo o enunciado, o Registo do Windows continha um vestígio do nome da ferramenta. A partir dessa informação, era necessário encontrar o timestamp correspondente e convertê-lo para o formato:

`AAAAMMDD HHMM`

---

## 7.2 Preservação e preparação da evidência

Antes de iniciar a análise forense, foi criada uma cópia da imagem original fornecida para o desafio *The Mirror*. Esta medida foi adotada para garantir que a evidência original permanecia intacta, sendo toda a análise realizada apenas sobre a cópia de trabalho.

A imagem original foi colocada na pasta `original`, enquanto a cópia utilizada na investigação foi colocada na pasta `copia`.

De seguida, foi calculado o hash SHA-256 de ambos os ficheiros, de forma a confirmar que a cópia era uma reprodução fiel da imagem original.

| Ficheiro | SHA-256 |
|---|---|
| `The Mirror Single.E01` | `F4A10ED08E1C6AB687E56854A6907866FBC472AA3E3F643CA89BA8462FCCC619` |
| `The Mirror Single Copy.E01` | `F4A10ED08E1C6AB687E56854A6907866FBC472AA3E3F643CA89BA8462FCCC619` |

Como os valores de hash obtidos são iguais, conclui-se que a cópia de trabalho mantém a mesma integridade da imagem original.

Além do hash SHA-256 calculado através do PowerShell, foi também utilizado o FTK Imager para verificar a integridade da imagem através dos valores MD5 e SHA1.

![Resultado da verificação da imagem no FTK Imager](<Imagens_Evidencias/Image_Drive Verify Results.png>)

| Algoritmo | Hash | Resultado |
|---|---|---|
| MD5 | `9918e566dc93ec18b1c4fcb1583a347a` | Match |
| SHA1 | `bd0c33a9faef491e123d25e76360e85944884ac0` | Match |

---

## 7.3 Abertura da imagem no FTK Imager

Após a verificação da integridade, a imagem de trabalho `The Mirror Single Copy.E01` foi aberta no FTK Imager.

Esta ferramenta foi utilizada para navegar pela estrutura da imagem em modo de leitura e exportar os artefactos necessários para análise posterior.

No FTK Imager foram identificadas várias partições, sendo a partição principal de interesse a:

`Basic data partition (3)`

Esta partição apresentava sistema de ficheiros NTFS e dimensão aproximada de 29714 MB. No seu interior foi identificada uma estrutura típica de um sistema Windows, incluindo as pastas:

- `Windows`
- `Users`
- `Program Files`
- `Program Files (x86)`
- `ProgramData`

Dentro da pasta `Users`, foi identificado o utilizador:

`d3vucci`

Este utilizador foi considerado relevante para a investigação, uma vez que o enunciado refere que a primeira missão decorre numa janela de `d3vucci` e envolve a procura de vestígios no Registo do Windows.

---

## 7.4 Artefactos exportados

A partir da imagem aberta no FTK Imager, foram exportados vários artefactos forenses para análise posterior. Estes artefactos incluem ficheiros do Registo do Windows, registos do utilizador, ficheiros Prefetch e logs do sistema.

A estrutura de ficheiros exportados ficou organizada da seguinte forma:

```text
exportados/
│
├── registry/
│   ├── d3vucci/
│   │   ├── NTUSER.DAT
│   │   └── UsrClass.dat
│   │
│   ├── windows/
│   │   ├── SYSTEM
│   │   ├── SOFTWARE
│   │   ├── SAM
│   │   ├── SECURITY
│   │   └── DEFAULT
│   │
│   └── Amcache.hve
│
├── prefetch/
│   └── ficheiros .pf
│
├── logs/
│   ├── Security.evtx
│   ├── System.evtx
│   ├── Application.evtx
│   ├── Microsoft-Windows-PowerShell%4Operational.evtx
│   └── Windows PowerShell.evtx
│
└── zips/
    ├── chest.7z
    └── backup_old.7z
```

Os ficheiros `NTUSER.DAT` e `UsrClass.dat` foram exportados a partir do perfil do utilizador `d3vucci`, permitindo analisar vestígios específicos desse utilizador, como programas executados, ficheiros recentes e interações com o sistema.

Os hives `SYSTEM`, `SOFTWARE`, `SAM`, `SECURITY` e `DEFAULT` foram exportados da pasta:

`Windows\System32\config`

Estes ficheiros contêm informação essencial do Registo do Windows. Também foi exportado o ficheiro `Amcache.hve`, útil para identificar executáveis presentes ou executados no sistema.

A pasta `Prefetch` foi exportada para permitir a análise de programas executados e respetivos timestamps.

Por fim, foram exportados os principais logs do Windows, incluindo `Security.evtx`, `System.evtx`, `Application.evtx` e logs relacionados com PowerShell, para eventual validação complementar.

---

## 7.5 Identificação da arca no ambiente de trabalho do utilizador

Após a identificação do utilizador `d3vucci`, foi analisado o seu perfil através do FTK Imager. A navegação foi realizada até à pasta do ambiente de trabalho do utilizador:

`Users\d3vucci\Desktop`

Esta pasta foi considerada relevante porque, em sistemas Windows, o ambiente de trabalho é uma localização comum para ficheiros deixados diretamente pelo utilizador ou por uma aplicação executada nesse contexto.

Além disso, o enunciado referia a existência de uma “arca trancada”, pelo que foram procurados ficheiros comprimidos ou protegidos por palavra-passe.

Dentro da pasta `Desktop`, foram identificados vários ficheiros com interesse para a investigação:

- `chest.7z`
- `backup_old.7z`
- `The Miracle and the Sleeper.txt`
- `THEMIR~1.TXT`

O ficheiro `chest.7z` foi considerado o principal candidato à “arca trancada”, uma vez que o termo *chest* corresponde a “arca” ou “baú”.

O ficheiro `backup_old.7z` também foi exportado para análise complementar, por poder conter uma versão anterior ou uma pista relacionada.

![Ficheiros encontrados no Desktop de d3vucci](<Imagens_Evidencias/Desktop_d3vucci_chest.png>)

Os ficheiros identificados foram exportados através do FTK Imager para a pasta de trabalho, de forma a poderem ser analisados fora da imagem forense.

A exportação foi feita para a diretoria:

`Exportados\zips`

Após a exportação, foi confirmada a presença dos ficheiros através da linha de comandos:

```powershell
dir
```

Desta forma, o ficheiro `chest.7z` foi assumido como a arca referida na Prova I, sendo posteriormente utilizado para validar a chave obtida a partir da análise do Registo e do Prefetch.

---

## 7.6 Conversão dos ficheiros Prefetch para CSV

Para facilitar a análise dos ficheiros Prefetch, foi utilizada a ferramenta `PECmd`, da suite de ferramentas de Eric Zimmerman.

Esta ferramenta permite efetuar o parsing dos ficheiros `.pf` do Windows e exportar os resultados para ficheiros `.csv`, tornando mais simples a pesquisa por executáveis, timestamps e caminhos associados.

O comando utilizado foi semelhante ao seguinte:

```powershell
.\PECmd.exe -d "C:\Users\Rodrigo\Desktop\Mestrado\2Semestre\Auditoria\Trabalho-Auditoria-AnaliseForense\Exportados\prefetch" --csv "C:\Users\Rodrigo\Desktop\Mestrado\2Semestre\Auditoria\Trabalho-Auditoria-AnaliseForense\Resultados\prefetch"
```

Neste comando, o parâmetro `-d` indica a diretoria onde se encontravam os ficheiros Prefetch exportados da imagem forense.

O parâmetro `--csv` define a pasta de destino onde foram guardados os resultados em formato CSV.

Após a execução do comando, os ficheiros CSV gerados foram analisados para procurar executáveis suspeitos e respetivos timestamps de execução. Este processo permitiu identificar ficheiros Prefetch associados aos executáveis:

- `SVCUTIL32.EXE`
- `CHEST_STAGE1.EXE`

---

## 7.7 Análise do Registo e identificação inicial de ficheiros suspeitos

Para identificar a ferramenta mascarada referida no enunciado, foi analisado o ficheiro `NTUSER.DAT` do utilizador `d3vucci` com recurso ao Registry Explorer.

A análise incidiu principalmente sobre os artefactos `UserAssist` e `RunMRU`, uma vez que estes podem guardar evidências de programas executados e comandos introduzidos pelo utilizador.

No Registry Explorer foi analisada a chave:

`Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist`

Numa primeira análise, foi identificado o executável:

`C:\Users\d3vucci\AppData\Local\Temp\svcutl\svcutl32.exe`

Este ficheiro foi considerado suspeito por se encontrar numa pasta temporária do perfil do utilizador, mais concretamente em:

`AppData\Local\Temp\svcutl\`

Além disso, o nome `svcutl32.exe` aparentava tentar imitar uma ferramenta legítima ou associada a serviços do Windows, o que o tornava compatível com a descrição da missão, que referia uma ferramenta mascarada.

![UserAssist com svcutl32.exe](<Imagens_Evidencias/Apps User Assist.png>)

Foi também analisada a chave:

`Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`

Nesta chave foi encontrada a entrada:

`svcutl32.exe`

O artefacto `RunMRU` regista comandos introduzidos através da janela Executar do Windows (`Win + R`). Assim, esta evidência reforçou inicialmente a hipótese de `svcutl32.exe` ser a ferramenta procurada.

![RunMRU com svcutl32.exe](<Imagens_Evidencias/RunMRU win_r.png>)

---

## 7.8 Validação da hipótese inicial

Após a identificação de `svcutl32.exe`, foi analisada a pasta `Prefetch`, previamente exportada da imagem forense.

Foi encontrado o ficheiro:

`SVCUTIL32.EXE-9E109D14.pf`

Este ficheiro estava associado ao executável:

`\USERS\D3VUCCI\APPDATA\LOCAL\TEMP\SVCUTIL\SVCUTIL32.EXE`

A análise do Prefetch indicou o seguinte timestamp de execução:

`2026-05-01 11:08:56`

![Ficheiro SVCUTIL32.EXE no Prefetch](<Imagens_Evidencias/SVCUTIL32_EXE no prefetch.png>)

![Resultado da análise do Prefetch de svcutl32.exe](<Imagens_Evidencias/svcutil32_exe no csv dos resultados timestamp do prefetch.png>)

Com base neste timestamp, foi construída uma chave no formato pedido no enunciado.

No entanto, esta combinação não permitiu abrir o ficheiro `chest.7z`, identificado no ambiente de trabalho do utilizador `d3vucci`.

Desta forma, apesar de `svcutl32.exe` ser um executável suspeito e relevante para a investigação, concluiu-se que este não correspondia à ferramenta responsável pela chave da Prova I.

A análise foi então alargada a outros executáveis presentes nos artefactos do Registo.

---

## 7.9 Identificação da ferramenta correta

Após a validação negativa da hipótese inicial, foi realizada uma nova pesquisa no `UserAssist`, procurando outros executáveis associados ao utilizador `d3vucci`.

Nesta análise foi identificado o executável:

`C:\Users\d3vucci\Desktop\chest_stage1.exe`

Este ficheiro revelou-se mais relevante para a missão, pois encontrava-se diretamente no ambiente de trabalho do utilizador e o seu nome estava associado à arca `chest.7z`, que precisava de ser aberta para avançar no desafio.

No `UserAssist`, o executável `chest_stage1.exe` apresentava o campo `Last Executed` com o seguinte valor:

`2026-05-01 12:08:53`

![UserAssist com chest_stage1.exe](<Imagens_Evidencias/UserAssist_chest_stage1.png>)

---

## 7.10 Confirmação através de Prefetch

Para confirmar a execução de `chest_stage1.exe`, foi novamente analisada a pasta `Prefetch` com recurso à ferramenta PECmd.

Foi identificado o ficheiro:

`CHEST_STAGE1.EXE-870BD780.pf`

Este ficheiro estava associado ao executável:

`\USERS\D3VUCCI\DESKTOP\CHEST_STAGE1.EXE`

A análise do Prefetch indicou que o programa foi executado e apresentou o seguinte timestamp:

`2026-05-01 12:09:03`

![Resultado da análise do Prefetch de CHEST_STAGE1.EXE](<Imagens_Evidencias/prefetch_chest_stage1.png>)

Este timestamp confirma o momento relevante de ativação da ferramenta.

Convertendo para o formato pedido no enunciado, `AAAAMMDD HHMM`, obtém-se:

`20260501 1209`

---

## 7.11 Validação da chave

Para validar a chave obtida, foi utilizado o 7-Zip para testar a abertura do ficheiro `chest.7z`, identificado no ambiente de trabalho do utilizador `d3vucci`.

O comando utilizado foi:

```powershell
"C:\Program Files\7-Zip\7z.exe" x "chest.7z" -p"20260501 1209" -o"chest_extraido"
```

A chave `20260501 1209` permitiu abrir corretamente a arca, confirmando que o timestamp identificado correspondia à resposta correta da Prova I.

Após a extração, foram obtidos os ficheiros contidos no arquivo, permitindo avançar para a fase seguinte do desafio.

---

## 7.12 Cronologia da Prova I

| Data/Hora | Fonte | Evento |
|---|---|---|
| 2026-05-01 11:08:56 | Prefetch | Execução de `SVCUTIL32.EXE` |
| 2026-05-01 12:08:53 | UserAssist | Execução de `C:\Users\d3vucci\Desktop\chest_stage1.exe` |
| 2026-05-01 12:09:03 | Prefetch | Execução confirmada de `CHEST_STAGE1.EXE` |
| 2026-05-01 12:13:10 | FTK Imager / Desktop | Identificação de `chest.7z` no ambiente de trabalho do utilizador |

Nota: os timestamps foram mantidos conforme apresentados pelas ferramentas utilizadas.

---

## 7.13 Indicadores de Compromisso / Artefactos relevantes

| Tipo | Indicador |
|---|---|
| Executável suspeito inicial | `C:\Users\d3vucci\AppData\Local\Temp\svcutl\svcutl32.exe` |
| Executável relevante para a chave | `C:\Users\d3vucci\Desktop\chest_stage1.exe` |
| Prefetch | `SVCUTIL32.EXE-9E109D14.pf` |
| Prefetch | `CHEST_STAGE1.EXE-870BD780.pf` |
| Arquivo protegido | `C:\Users\d3vucci\Desktop\chest.7z` |
| Artefacto de Registo | `NTUSER.DAT` |
| Chave de Registo | `Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist` |
| Chave de Registo | `Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU` |

---

## 7.14 Resultado da Prova I

Com base nas evidências recolhidas, conclui-se que a ferramenta mascarada associada à Prova I era:

`chest_stage1.exe`

A sua localização era:

`C:\Users\d3vucci\Desktop\chest_stage1.exe`

A execução foi confirmada através dos seguintes artefactos:

- `UserAssist`, onde foi registada a execução do programa;
- `Prefetch`, onde foi identificado o ficheiro `CHEST_STAGE1.EXE-870BD780.pf`.

O timestamp confirmado pelo Prefetch foi:

`2026-05-01 12:09:03`

Assim, a chave obtida para a Prova I foi:

`20260501 1209`

Esta chave foi validada através da abertura bem-sucedida do ficheiro `chest.7z`, correspondente à arca trancada referida no enunciado.

---

## 7.15 Resumo das evidências da Prova I

| Artefacto | Localização | Resultado |
|---|---|---|
| UserAssist | `NTUSER.DAT` de `d3vucci` | Identificação inicial de `svcutl32.exe` |
| RunMRU | `NTUSER.DAT` de `d3vucci` | Comando `svcutl32.exe` introduzido na janela Executar |
| Prefetch | `SVCUTIL32.EXE-9E109D14.pf` | Execução de `svcutl32.exe` em `2026-05-01 11:08:56`, mas a chave derivada não permitiu abrir a arca |
| UserAssist | `NTUSER.DAT` de `d3vucci` | Identificação de `C:\Users\d3vucci\Desktop\chest_stage1.exe` |
| Prefetch | `CHEST_STAGE1.EXE-870BD780.pf` | Confirmação da execução de `chest_stage1.exe` em `2026-05-01 12:09:03` |
| Chave obtida | Formato `AAAAMMDD HHMM` | `20260501 1209` |
| Validação | `chest.7z` | A chave permitiu abrir a arca |

---

## 7.16 Conclusão da Prova I

Com base nas evidências disponíveis, conclui-se com elevado grau de confiança que a ferramenta relevante para a Prova I era:

`chest_stage1.exe`

A análise iniciou-se com a identificação de `svcutl32.exe` como executável suspeito, devido à sua presença em `UserAssist`, `RunMRU` e Prefetch. No entanto, a chave derivada do timestamp associado a esse executável não permitiu abrir a arca `chest.7z`.

Por esse motivo, a pesquisa foi alargada a outros executáveis registados no `UserAssist`. Foi então identificado `chest_stage1.exe`, localizado no ambiente de trabalho do utilizador `d3vucci`.

A execução deste ficheiro foi confirmada pelo Prefetch `CHEST_STAGE1.EXE-870BD780.pf`, que apresentou o timestamp:

`2026-05-01 12:09:03`

Este valor permitiu obter a chave:

`20260501 1209`

A chave foi validada através da abertura bem-sucedida do ficheiro `chest.7z`.

Desta forma, a Prova I foi concluída com sucesso, permitindo avançar para a Prova II.

---

# 8. Prova II — O Espelho

> Secção a preencher após a análise dos ficheiros extraídos de `chest.7z`.

---

# 9. Prova III — The Glass Prison

> Secção a preencher após a análise do ambiente Linux.

---

# 10. Prova IV — The Glass Prison

> Secção a preencher após a análise do histórico e recuperação de ficheiros no ambiente Linux.

---

# 11. Prova V — The Shattered Fortress

> Secção a preencher após desbloqueio e análise do ambiente Android.

---

# 12. Conclusões gerais

> Secção a preencher no final da investigação, após a recolha das cinco provas.

---

# 13. Anexos

## Anexo A — Capturas de ecrã

| ID | Descrição | Ficheiro |
|---|---|---|
| ANX-A01 | Verificação de integridade no FTK Imager | `Image_Drive Verify Results.png` |
| ANX-A02 | UserAssist com `svcutl32.exe` | `Apps User Assist.png` |
| ANX-A03 | RunMRU com `svcutl32.exe` | `RunMRU win_r.png` |
| ANX-A04 | Prefetch de `SVCUTIL32.EXE` | `SVCUTIL32_EXE no prefetch.png` |
| ANX-A05 | UserAssist com `chest_stage1.exe` | `UserAssist_chest_stage1.png` |
| ANX-A06 | Prefetch de `CHEST_STAGE1.EXE` | `prefetch_chest_stage1.png` |
| ANX-A07 | Ficheiros encontrados no Desktop de `d3vucci` | `Desktop_d3vucci_chest.png` |

---

## Anexo B — Comandos utilizados

### Cálculo do hash SHA-256

```powershell
Get-FileHash ".\original\The Mirror Single.E01" -Algorithm SHA256
Get-FileHash ".\copia\The Mirror Single Copy.E01" -Algorithm SHA256
```

### Conversão de Prefetch para CSV

```powershell
.\PECmd.exe -d "C:\Users\Rodrigo\Desktop\Mestrado\2Semestre\Auditoria\Trabalho-Auditoria-AnaliseForense\Exportados\prefetch" --csv "C:\Users\Rodrigo\Desktop\Mestrado\2Semestre\Auditoria\Trabalho-Auditoria-AnaliseForense\Resultados\prefetch"
```

### Extração da arca com 7-Zip

```powershell
"C:\Program Files\7-Zip\7z.exe" x "chest.7z" -p"20260501 1209" -o"chest_extraido"
```

---

## Anexo C — Limitações

A análise documentada nesta versão incide apenas sobre a Prova I do ambiente Windows (*The Mirror*). As restantes provas serão documentadas após a análise dos respetivos ambientes e artefactos.

Os timestamps foram mantidos conforme apresentados pelas ferramentas utilizadas. Sempre que necessário, a interpretação temporal deverá considerar o fuso horário e o contexto da ferramenta usada.

---



# Prova 2 

## Passo1:
Analisar os ficheiros extraidos da prova 1 "note.txt" e "The Miracle and the Sleeper.txt".

O "The Miracle and the Sleeper.txt" diz:

    Nem tudo o que está escondido está guardado em arcas. Algumas verdades ficam agarradas à superfície de objetos comuns, invisíveis para quem não sabe procurar. Existe um documento na biblioteca do utilizador d3vucci que tem uma “segunda pele”: um símbolo/imagem escondido dentro de uma imagem, protegido pela palavra Metropolis. Encontra esse símbolo. O pergaminho/ficheiro selado na biblioteca irá revelar os seus segredos, se souberes como procurar.

Com base nesta informação, foi analisada a pasta:

`Users\d3vucci\Documents`

Através do FTKImager exportamos 2 ficheiros da pasta dos documentos: 

- notes.txt
- sealed-scroll.7z

## Passo 2: Análise inicial do ficheiro sealed-scroll.7z

Foi inicialmente listado o conteúdo do ficheiro `sealed-scroll.7z` com o 7-Zip:

```powershell
& "C:\Program Files\7-Zip\7z.exe" l ".\sealed-scroll.7z"
```

O arquivo continha um ficheiro chamado:

`linux-clue.txt`

De seguida, foi testada a password `Metropolis`:

```powershell
& "C:\Program Files\7-Zip\7z.exe" t ".\sealed-scroll.7z" -p"Metropolis"
```

O resultado indicou erro de password:

```powershell
ERROR: Data Error in encrypted file. Wrong password? : linux-clue.txt
```

Assim, concluiu-se que `Metropolis` não era a password direta do ficheiro `sealed-scroll.7z`, mas sim uma pista para desbloquear outro conteúdo escondido.

## Passo3: Pesquisa de uma imagem escondida no ficheiro notes.txt

O ficheiro notes.txt apresentava conteúdo textual no início, mas tinha um tamanho anormalmente elevado para um simples ficheiro de texto. Por isso, foi feita uma pesquisa por assinaturas de ficheiros no seu conteúdo binário.

```powershell
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
```

O resultado obtido foi:

`JPEG encontrado em offset decimal 94 / hex 0x5E`

Este resultado indica que, dentro do ficheiro `notes.txt`, existia uma imagem JPEG escondida a partir do offset `0x5E`.

## Passo 4: Extração da imagem a partir do notes.txt

Com base no offset identificado, foi feita a extração dos dados a partir do byte 94 até ao fim do ficheiro, criando uma imagem chamada notes_carved.jpg.

Ficheiro Powershell para extrair a imagem do Hexadecimal:

```powershell
$bytes = [System.IO.File]::ReadAllBytes("C:\Users\Rodrigo\Desktop\Mestrado\2Semestre\Auditoria\Trabalho-Auditoria-AnaliseForense\Prova2\Documents\notes.txt")

$start = 94
$length = $bytes.Length - $start

$out = New-Object byte[] $length
[Array]::Copy($bytes, $start, $out, 0, $length)

[System.IO.File]::WriteAllBytes("C:\Users\Rodrigo\Desktop\Mestrado\2Semestre\Auditoria\Trabalho-Auditoria-AnaliseForense\Prova2\Documents\notes_carved.jpg", $out)
```

## Passo 5: Extração de dados escondidos da imagem com steghide

Como a imagem extraída era um ficheiro JPEG, foi utilizada a ferramenta `steghide` através do Ubuntu para verificar se continha dados escondidos.

Instalação da ferramenta:

```bash
- sudo apt update
- sudo apt install steghide
```

Extração dos dados escondidos:

```bash
steghide extract -sf notes_carved.jpg -p Metropolis
```

A password Metropolis, indicada na pista, permitiu extrair um ficheiro chamado:

`secret.txt`

O conteúdo do ficheiro secret.txt era:

`Nf7#mK2@deploy`

Este valor foi interpretado como a password necessária para abrir o ficheiro `sealed-scroll.7z`.

## Passo 6: Abertura do ficheiro sealed-scroll.7z

Com a password obtida através da imagem, foi testado novamente o ficheiro `sealed-scroll.7z`:

```powershell
& "C:\Program Files\7-Zip\7z.exe" t ".\sealed-scroll.7z" -p"Nf7#mK2@deploy"
```

Após validação da password, o ficheiro foi extraído:

```powershell
& "C:\Program Files\7-Zip\7z.exe" x ".\sealed-scroll.7z" -p"Nf7#mK2@deploy" -o".\sealed_scroll_extraido"
```

O ficheiro extraído foi:

`linux-clue.txt`

Este ficheiro contém a pista para a fase seguinte da investigação, relacionada com o ambiente Linux.

## Conclusão da Prova 2

A Prova 2 permitiu demonstrar que o ficheiro `notes.txt`, aparentemente textual, continha uma imagem JPEG embutida a partir do offset `0x5E`. A imagem foi extraída através de file carving e analisada com a ferramenta `steghide`.

A palavra `Metropolis`, indicada na pista textual, não correspondia à password do arquivo `sealed-scroll.7z`, mas sim à password utilizada para extrair dados escondidos da imagem. O conteúdo extraído revelou a password `Nf7#mK2@deploy`, que permitiu abrir o arquivo `sealed-scroll.7z` e obter o ficheiro `linux-clue.txt`.

Assim, conclui-se que a cadeia de evidência da Prova 2 foi:

`The Miracle and the Sleeper.txt` → `notes.txt` → `notes_carved.jpg` → `secret.txt` → `sealed-scroll.7z` → `linux-clue.txt`