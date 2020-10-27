# CFML - SSO Integration Sample App

This is a simple integration with SSO Identity providers, using Okta as the default test. The code contained here is a simple drop in and go app.

## Getting Started


### Prerequisites

* CFML engine ([Lucee](https://lucee.org), [Commandbox](https://www.ortussolutions.com/products/commandbox), or [Adobe Coldfusion](https://www.adobe.com/products/coldfusion-family.html))
* Service Provider account from one of the currently supported Identity Providers
	* [okta](https://okta.com)

### Installing

1. Clone the git repo into a webroot being served by Lucee, CommandBox, or Adobe ColdFusion.

2. Configure this demo SAML app with the identity provider you are using (e.g., okta) and note the configuration settings as you will need them for the next step.

3. Navigate to the main page of this demo app and you'll be instructed on how to configure your Identity Provider settings for this app.

## Contributing

Would appreciate if you can contribute info additional service providers! This involves creating new persistent components that represent the service provider. See the ```saml/providers/okta.cfc``` as an example.

## Authors

* **Pankaj Sarin**, [opflo, llc](https://www.opflo.com) - https://github.com/psarin


## License

This project is licensed under the [MIT License](https://en.wikipedia.org/wiki/MIT_License). Terms can be found at LICENSE.md

## Acknowledgments

* The app code is based on code from https://github.com/GiancarloGomez/ColdFusion-OneLogin.N
	* Note that updated app does NOT use a database, and thus no ORM / database configuration is required prior to use.





