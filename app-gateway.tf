data "azurerm_key_vault_secret" "tribunals_frontend_cert" {
  name      = "${var.tribunals_frontend_external_cert_name}"
  vault_uri = "${var.external_cert_vault_uri}"
}

data "azurerm_subnet" "subnet_a" {
  name                 = "core-infra-subnet-0-${var.env}"
  virtual_network_name = "core-infra-vnet-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
}

locals {
  tribunals_frontend_suffix  = "${var.env != "prod" ? "-tribunals-frontend" : ""}"
  tribunals_frontend_internal_hostname  = "${var.product}-tribunals-frontend-${var.env}.service.core-compute-${var.env}.internal"
}

module "appGw" {
  source            = "git@github.com:hmcts/cnp-module-waf?ref=master"
  env               = "${var.env}"
  subscription      = "${var.subscription}"
  location          = "${var.location}"
  wafName           = "${var.product}"
  resourcegroupname = "${azurerm_resource_group.rg.name}"
  common_tags       = "${var.common_tags}"

  # vNet connections
  gatewayIpConfigurations = [
    {
      name     = "internalNetwork"
      subnetId = "${data.azurerm_subnet.subnet_a.id}"
    },
  ]

  sslCertificates = [
    {
      name     = "${var.tribunals_frontend_external_cert_name}${local.tribunals_frontend_suffix}"
      data     = "${data.azurerm_key_vault_secret.tribunals_frontend_cert.value}"
      password = ""
    },
  ]

  # Http Listeners
  httpListeners = [
    {
      name                    = "${var.product}-http-ni-redirect-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort80"
      Protocol                = "Http"
      SslCertificate          = ""
      hostName                = "${var.tribunals_frontend_external_hostname}"
    },
    {
      name                    = "${var.product}-https-listener-palo"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort443"
      Protocol                = "Https"
      SslCertificate          = "${var.tribunals_frontend_external_cert_name}${local.tribunals_frontend_suffix}"
      hostName                = "${var.tribunals_frontend_external_hostname}"
    },
  ]

  backendAddressPools = [
    {
      name             = "${var.product}-${var.env}-backend-palo"
      backendAddresses = "${module.palo_alto.untrusted_ips_fqdn}"
    },
    {
      name = "${var.product}-${var.env}-backend-ilb"

      backendAddresses = [
        {
          ipAddress = "${local.tribunals_frontend_internal_hostname}"
        },
      ]
    },
  ]

  backendHttpSettingsCollection = [
    {
      name                           = "backend-80-palo"
      port                           = 80
      Protocol                       = "Http"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "http-probe-palo"
      PickHostNameFromBackendAddress = "False"
      HostName                       = ""
    },
    {
      name                           = "backend-80-ilb"
      port                           = 80
      Protocol                       = "Http"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "http-probe-ilb"
      PickHostNameFromBackendAddress = "True"
      HostName                       = ""
    },
  ]

  # Request routing rules
  requestRoutingRules = [
    {
      name                = "http-palo"
      ruleType            = "Basic"
      httpListener        = "${var.product}-https-listener-palo"
      backendAddressPool  = "${var.product}-${var.env}-backend-palo"
      backendHttpSettings = "backend-80-palo"
    },
    {
      name                = "http-ilb"
      ruleType            = "Basic"
      httpListener        = "${var.product}-https-listener-ilb"
      backendAddressPool  = "${var.product}-${var.env}-backend-ilb"
      backendHttpSettings = "backend-80-ilb"
    },
  ]

  probes = [
    {
      name                = "http-probe-palo"
      protocol            = "Http"
      path                = "/health"
      interval            = 30
      timeout             = 30
      unhealthyThreshold  = 5
      backendHttpSettings = "backend-80-palo"
      healthyStatusCodes  = "200"
      host                = "${local.tribunals_frontend_internal_hostname}"
    },
  ]
}