defmodule CuexWeb.ConversionView do
  use CuexWeb, :view
  alias CuexWeb.ConversionView

  def render("index.json", %{conversion_histories: conversion_histories}) do
    %{data: render_many(conversion_histories, ConversionView, "conversion_history.json")}
  end

  def render("show.json", %{conversion: conversion}) do
    %{data: render_one(conversion, ConversionView, "conversion.json")}
  end

  def render("conversion.json", %{conversion: conversion}) do
    %{
      id: conversion.id,
      user_id: conversion.user_id,
      from_currency: conversion.from_currency,
      to_currency: conversion.to_currency,
      value: conversion.value,
      converted_value: conversion.converted_value,
      conversion_rate: conversion.conversion_rate,
      date: conversion.inserted_at
    }
  end

  def render("conversion_history.json", %{conversion: conversion}) do
    %{
      id: conversion.id,
      user_id: conversion.user_id,
      from_currency: conversion.from_currency,
      to_currency: conversion.to_currency,
      value: conversion.value,
      conversion_rate: conversion.conversion_rate
    }
  end
end
