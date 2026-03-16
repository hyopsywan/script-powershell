# Importa o módulo do Active Directory
Import-Module ActiveDirectory

# Caminho do arquivo CSV contendo os usuários que devem ser desativados
$ArquivoUsuarios = "C:\Users\BRNSS0-06\Documents\AtividadesSO\Relatorios\usuarios_desligados.csv"

# Importa o conteúdo do CSV para uma variável
$UsuariosDesligados = Import-Csv -Path $ArquivoUsuarios

# Caminho do arquivo de log que registrará as ações executadas
$LogPath = "C:\Users\BRNSS0-06\Documents\AtividadesSO\Relatorios\LogDesativacao.txt"

# Percorre cada usuário listado no arquivo CSV
foreach ($Usuario in $UsuariosDesligados) {

    # Captura o valor da coluna que contém o login do usuário
    $SamAccountName = $Usuario.usuario_desligado

    # Procura o usuário no Active Directory
    # CORREÇÃO: uso de variável no filtro
    $ContaUsuario = Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -ErrorAction SilentlyContinue

    # Verifica se o usuário existe
    if ($ContaUsuario) {

        # Desativa a conta do usuário
        Disable-ADUser -Identity $SamAccountName

        # Exibe mensagem no console
        Write-Host "Usuário $SamAccountName desativado."

        # Registra a ação no arquivo de log
        Add-Content -Path $LogPath -Value "$(Get-Date) - Usuário $SamAccountName desativado com sucesso."
    }

    else {

        # Caso o usuário não exista no AD
        Write-Host "Usuário $SamAccountName não encontrado no Active Directory."

        # Registra no log
        Add-Content -Path $LogPath -Value "$(Get-Date) - Usuário $SamAccountName não encontrado no Active Directory."
    }
}

# Mensagem final informando onde verificar o log
Write-Host "Processo concluído. Consulte o log em $LogPath."
