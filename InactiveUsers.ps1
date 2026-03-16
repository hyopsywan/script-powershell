# Importa o módulo do Active Directory para usar os comandos de gerenciamento
Import-Module ActiveDirectory

# Define quantos dias sem login serão considerados como inatividade
$DaysInactive = 90

# Calcula a data limite para considerar a conta inativa
$DateThreshold = (Get-Date).AddDays(-$DaysInactive)

# Busca usuários que:
# - Estão habilitados
# - Não fazem login desde a data limite definida
$InactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $DateThreshold -and Enabled -eq $true} -Properties LastLogonDate

# Busca computadores que não fazem login desde a data limite
$InactiveComputers = Get-ADComputer -Filter {LastLogonDate -lt $DateThreshold} -Properties LastLogonDate

# Organiza os dados dos usuários inativos para gerar relatório
$UserReport = $InactiveUsers |
Select-Object Name, SamAccountName, LastLogonDate, Enabled |
Sort-Object LastLogonDate

# Organiza os dados dos computadores inativos
$ComputerReport = $InactiveComputers |
Select-Object Name, LastLogonDate, Enabled |
Sort-Object LastLogonDate

# Caminhos onde os relatórios serão salvos
$UserReportPath = "C:\Users\BRNSS0-06\Documents\AtividadesSO\Relatorios\UsuariosInativos.csv"

# CORREÇÃO: faltava "\" depois do C:
$ComputerReportPath = "C:\Users\BRNSS0-06\Documents\AtividadesSO\Relatorios\ComputadoresInativos.csv"

# Exporta os relatórios em formato CSV
$UserReport | Export-Csv -Path $UserReportPath -NoTypeInformation -Encoding UTF8
$ComputerReport | Export-Csv -Path $ComputerReportPath -NoTypeInformation -Encoding UTF8

# Exibe mensagem confirmando geração dos relatórios
Write-Host "Relatórios gerados e salvos em C:\Users\BRNSS0-06\Documents\AtividadesSO\Relatorios."

# Desativa todos os usuários considerados inativos
$InactiveUsers | ForEach-Object { 
    Disable-ADUser -Identity $_.SamAccountName
    Write-Host "Usuário $($_.Name) foi desativado." 
}

# Desativa os computadores considerados inativos
$InactiveComputers | ForEach-Object { 
    Disable-ADAccount -Identity $_.Name
    Write-Host "Computador $($_.Name) foi desativado." 
}

# Configuração das informações de envio de e-mail
$AdminEmail = "administrator@senai.sp"
$FromEmail = "notificacoes@senai.sp"
$SMTPServer = "smtp.senai.sp"

# Corpo do e-mail que será enviado ao administrador
$EmailBody = @"
Relatório de Contas Inativas

Usuários Inativos: $($UserReport.Count)
Computadores Inativos: $($ComputerReport.Count)

Ação realizada:
Todas as contas inativas foram desativadas.

Os relatórios detalhados estão anexados.
"@

# Envia e-mail com os relatórios gerados anexados
Send-MailMessage -To $AdminEmail `
                 -From $FromEmail `
                 -Subject "Relatório de Contas Inativas" `
                 -Body $EmailBody `
                 -SmtpServer $SMTPServer `
                 -Attachments $UserReportPath, $ComputerReportPath

# Confirma envio da notificação
Write-Host "Notificação enviada ao administrador com os relatórios anexados."
