# Scripts de Gerenciamento de Usuários no Active Directory

Este repositório contém scripts em PowerShell para automação básica de gerenciamento de usuários em um ambiente de Active Directory.

Os scripts foram desenvolvidos como prática de administração de sistemas e segurança, com foco em automação, gerenciamento de contas e boas práticas operacionais.

## Scripts

### AddUsers.ps1
Lê uma lista de usuários a partir de um arquivo e:
- verifica se o grupo do departamento existe
- cria o grupo caso não exista
- adiciona os usuários aos respectivos grupos

### InactiveUsers.ps1
Identifica usuários e computadores inativos no Active Directory com base em um período definido de inatividade.

O script:
- gera relatórios de contas inativas
- desativa usuários e máquinas inativas
- envia uma notificação por e-mail com os relatórios gerados

### DisableUsers.ps1
Desativa contas de usuários com base em um arquivo CSV contendo uma lista de usuários que devem ser desativados.

O script também registra as ações realizadas em um arquivo de log para fins de auditoria.

## Tecnologias Utilizadas

- PowerShell
- Módulo Active Directory
- Windows Server

## Objetivo

Esses scripts foram desenvolvidos para aprendizado e experimentação com:

- administração de Active Directory
- automação de tarefas administrativas
- gerenciamento do ciclo de vida de contas
- práticas básicas de segurança operacional
