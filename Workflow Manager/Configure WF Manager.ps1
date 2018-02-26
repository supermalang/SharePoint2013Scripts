# À exécuter dans la console PowerShell de Workflow Manager dans laquelle sont installés Workflow Manager et Service Bus.

# Créer une batterie de serveurs SB
$SBCertificateAutoGenerationKey = ConvertTo-SecureString -AsPlainText  -Force  -String '***** Remplacer par la clé de génération automatique du certificat Service Bus ******' -Verbose;


New-SBFarm -SBFarmDBConnectionString 'Data Source=sql1.ibnet.com;Initial Catalog=SharePoint_SbManagementDB;Integrated Security=True;Encrypt=False' -InternalPortRangeStart 9000 -TcpPort 9354 -MessageBrokerPort 9356 -RunAsAccount 'spadmin@IBNET' -AdminGroup 'BUILTIN\Administrateurs' -GatewayDBConnectionString 'Data Source=sql1.ibnet.com;Initial Catalog=SharePoint_SbGatewayDatabase;Integrated Security=True;Encrypt=False' -CertificateAutoGenerationKey $SBCertificateAutoGenerationKey -MessageContainerDBConnectionString 'Data Source=sql1.ibnet.com;Initial Catalog=SharePoint_SBMessageContainer01;Integrated Security=True;Encrypt=False' -Verbose;

# À exécuter dans la console PowerShell de Workflow Manager dans laquelle sont installés Workflow Manager et Service Bus.

# Créer une batterie de serveurs WF
$WFCertAutoGenerationKey = ConvertTo-SecureString -AsPlainText  -Force  -String '***** Remplacer par la clé de génération automatique du certificat Workflow Manager ******' -Verbose;


New-WFFarm -WFFarmDBConnectionString 'Data Source=sql1.ibnet.com;Initial Catalog=SharePoint_WFManagementDB;Integrated Security=True;Encrypt=False' -RunAsAccount 'spadmin@IBNET.COM' -AdminGroup 'BUILTIN\Administrateurs' -HttpsPort 12290 -HttpPort 12291 -InstanceDBConnectionString 'Data Source=sql1.ibnet.com;Initial Catalog=SharePoint_WFInstanceManagementDB;Integrated Security=True;Encrypt=False' -ResourceDBConnectionString 'Data Source=sql1.ibnet.com;Initial Catalog=SharePoint_WFResourceManagementDB;Integrated Security=True;Encrypt=False' -CertificateAutoGenerationKey $WFCertAutoGenerationKey -Verbose;

# Ajouter un hôte SB
$SBRunAsPassword = ConvertTo-SecureString -AsPlainText  -Force  -String '***** Remplacer par un mot de passe RunAs pour Service Bus ******' -Verbose;


Add-SBHost -SBFarmDBConnectionString 'Data Source=sql1.ibnet.com;Initial Catalog=SharePoint_SbManagementDB;Integrated Security=True;Encrypt=False' -RunAsPassword $SBRunAsPassword -EnableFirewallRules $true -CertificateAutoGenerationKey $SBCertificateAutoGenerationKey -Verbose;

Try
{
    # Créer un espace de noms SB
    New-SBNamespace -Name 'WorkflowDefaultNamespace' -AddressingScheme 'Path' -ManageUsers 'spadmin@IBNET.COM','spadmin@IBNET' -Verbose;

    Start-Sleep -s 90
}
Catch [system.InvalidOperationException]
{
}

# Obtenir la configuration du client SB
$SBClientConfiguration = Get-SBClientConfiguration -Namespaces 'WorkflowDefaultNamespace' -Verbose;

# Ajouter un hôte WF
$WFRunAsPassword = ConvertTo-SecureString -AsPlainText  -Force  -String '***** Remplacer par un mot de passe RunAs pour Workflow Manager ******' -Verbose;


Add-WFHost -WFFarmDBConnectionString 'Data Source=sql1.ibnet.com;Initial Catalog=SharePoint_WFManagementDB;Integrated Security=True;Encrypt=False' -RunAsPassword $WFRunAsPassword -EnableFirewallRules $true -SBClientConfiguration $SBClientConfiguration -EnableHttpPort  -CertificateAutoGenerationKey $WFCertAutoGenerationKey -Verbose;
