# CuEx

[![Build Status](https://github.com/gabriel-fabian/cuex/actions/workflows/ci.yml/badge.svg)](https://github.com/gabriel-fabian/cuex/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/gabriel-fabian/cuex/badge.svg?branch=master)](https://coveralls.io/github/gabriel-fabian/cuex?branch=master)

## Table of Contents

- [Introduction](#introduction)
  - [Used Technologies](#used-technologies)
    * [Phoenix](#phoenix)
    * [Heroku](#heroku)
    * [Docker](#docker)
    * [Coveralls](#coveralls)
    * [Github Actins](#github-actions)
- [Development Setup](#development-setup)
  * [Setup With Docker](#setup-with-docker-recommended)
  * [Setup With Local Environment](#setup-with-local-environment-not-recommended)
- [Available Endpoints](#available-endpoints)
  * [Converting Currencies](#converting-currencies)
  * [Retrieving Requests Index](#retrieving-requests-index)
  * [Retrieving User Requests](#retrieving-user-requests)
- [Available Currencies](#available-currencies)


## **Introduction**

CuEx is a Currency Exchange API made with Elixir + Phoenix.

The purpose of this project is to make a RESTful API to provide a currency conversion between two currencies. It's based on exchange rates from an external API that provides exchange rates for Euro currency.

## **Used Technologies**

### **Phoenix**
[Phoenix](https://www.phoenixframework.org) is a well structured and production ready framework that provides a quick way to create APIs.

### **Heroku**
[Heroku](https://heroku.com) is a cloud platform to host apps. It provides a free plan and easy to go setup with Github for deployment and application testing.

### **Docker**
Docker is used to provide an easy setup for development and production deployment.
Don't worry to setup your environment locally, Docker will make a container with the application ready for testing and without the pollution of the `_build` and `deps` folders. Just focus on the code.

### **Coveralls**
[Coveralls](https://coveralls.io/) can host test coverage details for you application.
Used with [ExCoveralls](https://github.com/parroty/excoveralls) dependency to automatically send the coverage details to the Coveralls website.

### **Github Actions**
Github Actions is used to run CI environment. It assures that the project is building, none of the tests are breaking and check code linting.

##  **Development Setup**

Note that in the development environment the external API is mocked and doesn't offer real time rates.

### **Setup With Docker (Recommended)**

This setup is recommended because it provides an easy and fast method to run the project without worries of setting up the elixir and phoenix environment, besides it does not polute the repository with the `_build` and `deps` files generated on Phoenix builds.

**Step 1** - Install [Docker Compose](https://docs.docker.com/compose/install/);

**Step 2** - Clone this repository;

**Step 3** - Run `docker-compose up` inside the repository folder.

Now the application is up and running on `localhost:4000`

### **Setup With Local Environment (Not Recommended)**

⚠️ This doc will not cover the entire configuration process.

**Step 1** - Install Elixir, Erlang and Phoenix.

Required Versions:
- Elixir 1.12.3
- Erlang 24
- Phoenix 1.6.5

Check out the [ASDF](https://github.com/asdf-vm/asdf) github repository for managing language versions

OR

Check the official [Elixir](https://elixir-lang.org/install.html) or [Phoenix](https://hexdocs.pm/phoenix/installation.html) docs for installation process.

**Step 2** - Clone this repository;

**Step 3** - Run `mix deps.get` inside this repository;

**Step 4** - Run `mix phx.server` to start the server.

Now the application is up and running on `localhost:4000`

## **Available Endpoints**

This API offers three endpoints, one for converting values between two currencies and two other for listing all requests or user specific ones.

### **Converting Currencies**

To convert value between two currencies, you can make a `POST` request to `https://cuex-app.herokuapp.com/api/convert` for the deployed app on Heroku or `localhost:4000/api/convert` when using in development mode. This request needs a Json body with valid currency types as follows:

``` elixir
{
  "from_currency":"EUR",
  "to_currency":"BRL",
  "value":10.5,
  "user_id": 1
}
```

For a list containing all currencies check the [Available Currencies](#available-currencies) section.

### **Retrieving Conversions Index**

This endpoint lists all conversions made by the API. Simply do a `GET` request to `https://cuex-app.herokuapp.com/api/conversions` or `localhost:4000/api/conversions` to list all conversions.

This route accepts pagination as an option. If you desire to paginate your requests just add a query param to specify the page and number of rows. Ex: `https://cuex-app.herokuapp.com/api/conversions?page=1&page_size=15`

### **Retrieving User conversions**

This endpoint lists all conversions made to the API by the given user id. Simply do a `GET` request to `https://cuex-app.herokuapp.com/api/conversions/user/:id` or `localhost:4000/api/conversions/user/:id` where `:id` needs to be overwritten by the specific user id.

This route accepts pagination as an option. If you desire to paginate your requests just add a query param to specify the page and number of rows. Ex: `https://cuex-app.herokuapp.com/api/conversions/user/1?page=1&page_size=15`

## **Available Currencies**

This is a list containing all currencies available for conversion.
<details>

* ``AED - "United Arab Emirates Dirham",``
* ``AFN - "Afghan Afghani",``
* ``ALL - "Albanian Lek",``
* ``AMD - "Armenian Dram",``
* ``ANG - "Netherlands Antillean Guilder",``
* ``AOA - "Angolan Kwanza",``
* ``ARS - "Argentine Peso",``
* ``AUD - "Australian Dollar",``
* ``AWG - "Aruban Florin",``
* ``AZN - "Azerbaijani Manat",``
* ``BAM - "Bosnia-Herzegovina Convertible Mark",``
* ``BBD - "Barbadian Dollar",``
* ``BDT - "Bangladeshi Taka",``
* ``BGN - "Bulgarian Lev",``
* ``BHD - "Bahraini Dinar",``
* ``BIF - "Burundian Franc",``
* ``BMD - "Bermudan Dollar",``
* ``BND - "Brunei Dollar",``
* ``BOB - "Bolivian Boliviano",``
* ``BRL - "Brazilian Real",``
* ``BSD - "Bahamian Dollar",``
* ``BTC - "Bitcoin",``
* ``BTN - "Bhutanese Ngultrum",``
* ``BWP - "Botswanan Pula",``
* ``BYN - "New Belarusian Ruble",``
* ``BYR - "Belarusian Ruble",``
* ``BZD - "Belize Dollar",``
* ``CAD - "Canadian Dollar",``
* ``CDF - "Congolese Franc",``
* ``CHF - "Swiss Franc",``
* ``CLF - "Chilean Unit of Account (UF)",``
* ``CLP - "Chilean Peso",``
* ``CNY - "Chinese Yuan",``
* ``COP - "Colombian Peso",``
* ``CRC - "Costa Rican Colón",``
* ``CUC - "Cuban Convertible Peso",``
* ``CUP - "Cuban Peso",``
* ``CVE - "Cape Verdean Escudo",``
* ``CZK - "Czech Republic Koruna",``
* ``DJF - "Djiboutian Franc",``
* ``DKK - "Danish Krone",``
* ``DOP - "Dominican Peso",``
* ``DZD - "Algerian Dinar",``
* ``EGP - "Egyptian Pound",``
* ``ERN - "Eritrean Nakfa",``
* ``ETB - "Ethiopian Birr",``
* ``EUR - "Euro",``
* ``FJD - "Fijian Dollar",``
* ``FKP - "Falkland Islands Pound",``
* ``GBP - "British Pound Sterling",``
* ``GEL - "Georgian Lari",``
* ``GGP - "Guernsey Pound",``
* ``GHS - "Ghanaian Cedi",``
* ``GIP - "Gibraltar Pound",``
* ``GMD - "Gambian Dalasi",``
* ``GNF - "Guinean Franc",``
* ``GTQ - "Guatemalan Quetzal",``
* ``GYD - "Guyanaese Dollar",``
* ``HKD - "Hong Kong Dollar",``
* ``HNL - "Honduran Lempira",``
* ``HRK - "Croatian Kuna",``
* ``HTG - "Haitian Gourde",``
* ``HUF - "Hungarian Forint",``
* ``IDR - "Indonesian Rupiah",``
* ``ILS - "Israeli New Sheqel",``
* ``IMP - "Manx pound",``
* ``INR - "Indian Rupee",``
* ``IQD - "Iraqi Dinar",``
* ``IRR - "Iranian Rial",``
* ``ISK - "Icelandic Króna",``
* ``JEP - "Jersey Pound",``
* ``JMD - "Jamaican Dollar",``
* ``JOD - "Jordanian Dinar",``
* ``JPY - "Japanese Yen",``
* ``KES - "Kenyan Shilling",``
* ``KGS - "Kyrgystani Som",``
* ``KHR - "Cambodian Riel",``
* ``KMF - "Comorian Franc",``
* ``KPW - "North Korean Won",``
* ``KRW - "South Korean Won",``
* ``KWD - "Kuwaiti Dinar",``
* ``KYD - "Cayman Islands Dollar",``
* ``KZT - "Kazakhstani Tenge",``
* ``LAK - "Laotian Kip",``
* ``LBP - "Lebanese Pound",``
* ``LKR - "Sri Lankan Rupee",``
* ``LRD - "Liberian Dollar",``
* ``LSL - "Lesotho Loti",``
* ``LTL - "Lithuanian Litas",``
* ``LVL - "Latvian Lats",``
* ``LYD - "Libyan Dinar",``
* ``MAD - "Moroccan Dirham",``
* ``MDL - "Moldovan Leu",``
* ``MGA - "Malagasy Ariary",``
* ``MKD - "Macedonian Denar",``
* ``MMK - "Myanma Kyat",``
* ``MNT - "Mongolian Tugrik",``
* ``MOP - "Macanese Pataca",``
* ``MRO - "Mauritanian Ouguiya",``
* ``MUR - "Mauritian Rupee",``
* ``MVR - "Maldivian Rufiyaa",``
* ``MWK - "Malawian Kwacha",``
* ``MXN - "Mexican Peso",``
* ``MYR - "Malaysian Ringgit",``
* ``MZN - "Mozambican Metical",``
* ``NAD - "Namibian Dollar",``
* ``NGN - "Nigerian Naira",``
* ``NIO - "Nicaraguan Córdoba",``
* ``NOK - "Norwegian Krone",``
* ``NPR - "Nepalese Rupee",``
* ``NZD - "New Zealand Dollar",``
* ``OMR - "Omani Rial",``
* ``PAB - "Panamanian Balboa",``
* ``PEN - "Peruvian Nuevo Sol",``
* ``PGK - "Papua New Guinean Kina",``
* ``PHP - "Philippine Peso",``
* ``PKR - "Pakistani Rupee",``
* ``PLN - "Polish Zloty",``
* ``PYG - "Paraguayan Guarani",``
* ``QAR - "Qatari Rial",``
* ``RON - "Romanian Leu",``
* ``RSD - "Serbian Dinar",``
* ``RUB - "Russian Ruble",``
* ``RWF - "Rwandan Franc",``
* ``SAR - "Saudi Riyal",``
* ``SBD - "Solomon Islands Dollar",``
* ``SCR - "Seychellois Rupee",``
* ``SDG - "Sudanese Pound",``
* ``SEK - "Swedish Krona",``
* ``SGD - "Singapore Dollar",``
* ``SHP - "Saint Helena Pound",``
* ``SLL - "Sierra Leonean Leone",``
* ``SOS - "Somali Shilling",``
* ``SRD - "Surinamese Dollar",``
* ``STD - "São Tomé and Príncipe dobra",``
* ``SVC - "Salvadoran Colón",``
* ``SYP - "Syrian Pound",``
* ``SZL - "Swazi Lilangeni",``
* ``THB - "Thai Baht",``
* ``TJS - "Tajikistani Somoni",``
* ``TMT - "Turkmenistani Manat",``
* ``TND - "Tunisian Dinar",``
* ``TOP - "Tongan Pa\u02bbanga",``
* ``TRY - "Turkish Lira",``
* ``TTD - "Trinidad and Tobago Dollar",``
* ``TWD - "New Taiwan Dollar",``
* ``TZS - "Tanzanian Shilling",``
* ``UAH - "Ukrainian Hryvnia",``
* ``UGX - "Ugandan Shilling",``
* ``USD - "United States Dollar",``
* ``UYU - "Uruguayan Peso",``
* ``UZS - "Uzbekistan Som",``
* ``VEF - "Venezuelan Bolívar Fuerte",``
* ``VND - "Vietnamese Dong",``
* ``VUV - "Vanuatu Vatu",``
* ``WST - "Samoan Tala",``
* ``XAF - "CFA Franc BEAC",``
* ``XAG - "Silver (troy ounce)",``
* ``XAU - "Gold (troy ounce)",``
* ``XCD - "East Caribbean Dollar",``
* ``XDR - "Special Drawing Rights",``
* ``XOF - "CFA Franc BCEAO",``
* ``XPF - "CFP Franc",``
* ``YER - "Yemeni Rial",``
* ``ZAR - "South African Rand",``
* ``ZMK - "Zambian Kwacha (pre-2013)",``
* ``ZMW - "Zambian Kwacha",``
* ``ZWL - "Zimbabwean Dollar"``

 </details>
