defmodule Cuex.Api.Mock.ExchangeRate do
  @mocked_body "{\"success\":true,\"timestamp\":1640800143,\"base\":\"EUR\",\"date\":\"2021-12-29\",\"rates\":{\"AED\":4.164288,\"AFN\":117.628188,\"ALL\":120.860134,\"AMD\":542.666467,\"ANG\":2.044214,\"AOA\":638.447286,\"ARS\":116.439972,\"AUD\":1.564875,\"AWG\":2.040782,\"AZN\":1.926045,\"BAM\":1.963307,\"BBD\":2.290219,\"BDT\":97.312448,\"BGN\":1.954734,\"BHD\":0.427369,\"BIF\":2269.802668,\"BMD\":1.133768,\"BND\":1.536046,\"BOB\":7.820648,\"BRL\":6.453748,\"BSD\":1.134269,\"BTC\":2.3797451e-5,\"BTN\":84.774947,\"BWP\":13.297279,\"BYN\":2.859289,\"BYR\":22221.8443,\"BZD\":2.286608,\"CAD\":1.451506,\"CDF\":2269.802457,\"CHF\":1.037556,\"CLF\":0.034946,\"CLP\":964.280618,\"CNY\":7.220281,\"COP\":4564.434845,\"CRC\":728.146562,\"CUC\":1.133768,\"CUP\":30.044841,\"CVE\":110.994276,\"CZK\":24.970077,\"DJF\":201.49303,\"DKK\":7.435304,\"DOP\":64.681212,\"DZD\":157.59259,\"EGP\":17.812592,\"ERN\":17.006602,\"ETB\":55.611154,\"EUR\":1,\"FJD\":2.414986,\"FKP\":0.85529,\"GBP\":0.840972,\"GEL\":3.497639,\"GGP\":0.85529,\"GHS\":6.972467,\"GIP\":0.85529,\"GMD\":59.52081,\"GNF\":10544.038157,\"GTQ\":8.751929,\"GYD\":237.302289,\"HKD\":8.840042,\"HNL\":27.618786,\"HRK\":7.520317,\"HTG\":114.333273,\"HUF\":370.209366,\"IDR\":16127.673566,\"ILS\":3.536899,\"IMP\":0.85529,\"INR\":84.541307,\"IQD\":1654.733763,\"IRR\":47930.023446,\"ISK\":147.401274,\"JEP\":0.85529,\"JMD\":174.720246,\"JOD\":0.803868,\"JPY\":130.341884,\"KES\":128.263184,\"KGS\":96.13306,\"KHR\":4616.701099,\"KMF\":493.812467,\"KPW\":1020.390722,\"KRW\":1344.631307,\"KWD\":0.343066,\"KYD\":0.945275,\"KZT\":494.307001,\"LAK\":12664.183491,\"LBP\":1715.390678,\"LKR\":229.970037,\"LRD\":163.601845,\"LSL\":17.788605,\"LTL\":3.347721,\"LVL\":0.685804,\"LYD\":5.226472,\"MAD\":10.521806,\"MDL\":20.13568,\"MGA\":4489.719348,\"MKD\":61.842323,\"MMK\":2016.704415,\"MNT\":3240.743812,\"MOP\":9.108381,\"MRO\":404.754826,\"MUR\":49.421398,\"MVR\":17.516676,\"MWK\":920.619647,\"MXN\":23.318762,\"MYR\":4.739714,\"MZN\":72.368192,\"NAD\":17.788452,\"NGN\":466.201497,\"NIO\":40.107026,\"NOK\":9.967348,\"NPR\":135.640595,\"NZD\":1.660182,\"OMR\":0.436458,\"PAB\":1.134269,\"PEN\":4.499915,\"PGK\":3.996563,\"PHP\":57.896405,\"PKR\":201.98129,\"PLN\":4.597677,\"PYG\":7713.252807,\"QAR\":4.128063,\"RON\":4.950027,\"RSD\":117.569012,\"RUB\":84.033039,\"RWF\":1142.270823,\"SAR\":4.256251,\"SBD\":9.187768,\"SCR\":14.592939,\"SDG\":496.037502,\"SEK\":10.253488,\"SGD\":1.532978,\"SHP\":1.561655,\"SLL\":12851.255368,\"SOS\":662.12009,\"SRD\":22.45875,\"STD\":23466.699555,\"SVC\":9.925799,\"SYP\":2848.582828,\"SZL\":17.788565,\"THB\":37.973843,\"TJS\":12.805772,\"TMT\":3.968186,\"TND\":3.256182,\"TOP\":2.583006,\"TRY\":14.357689,\"TTD\":7.707632,\"TWD\":31.339597,\"TZS\":2614.460115,\"UAH\":30.892644,\"UGX\":4015.259516,\"USD\":1.133768,\"UYU\":50.457474,\"UZS\":12267.365088,\"VEF\":242433770784.02618,\"VND\":25875.410282,\"VUV\":128.402185,\"WST\":2.94799,\"XAF\":658.377099,\"XAG\":0.049697,\"XAU\":0.000629,\"XCD\":3.064063,\"XDR\":0.810379,\"XOF\":657.019677,\"XPF\":120.037663,\"YER\":283.725614,\"ZAR\":18.035351,\"ZMK\":10205.268947,\"ZMW\":18.870863,\"ZWL\":365.072694}}"

  def fetch_rates() do
    {:ok, Poison.decode!(@mocked_body)}
  end
end
