defmodule DemoWeb.Live.Classes do
  @moduledoc false

  # Home page classes (starting)

  # Home page classes (ending)

  def debug_info() do
    "p-2 bg-blue-50 rounded text-sm text-gray-600"
  end

  def read_only_value(has_value?) do
    base =
      "w-full px-3 py-2 text-lg border border-gray-300 rounded-md focus:outline-none min-h-[2.75rem]"

    if has_value? do
      base <> " bg-gray-100 text-gray-600"
    else
      base <> " text-gray-400"
    end
  end

  def editable_value() do
    "w-full px-3 py-2 text-lg border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:bg-gray-100"
  end

  def label() do
    "block text-sm font-medium text-gray-700 mb-1"
  end

  def debug_pre() do
    "mt-2 p-4 text-gray-600 bg-blue-50 rounded text-sm overflow-x-auto font-mono"
  end

  def dev_paragraph() do
    "mt-2 py-1 font-mono"
  end

  def dev_header() do
    "my-1 py-1 font-bold"
  end

  def dev_bulletpoint() do
    ""
  end

  def devs_chevron() do
    "cursor-pointer bg-blue-50 hover:bg-blue-100 p-4 border border-gray-200 rounded-lg mt-4 transition-colors"
  end
end
