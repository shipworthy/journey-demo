defmodule DemoWeb.Live.Classes do
  # Home page classes (starting)

  # Home page classes (ending)
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

  def summary() do
    "cursor-pointer text-md text-gray-500 hover:text-gray-700"
  end

  def debug_pre() do
    "mt-2 p-4 bg-gray-100 rounded text-md overflow-x-auto font-mono"
  end

  def computation_state() do
    "mt-2 p-2 bg-gray-50 border rounded text-xs font-mono whitespace-pre-line overflow-x-auto text-left indent-0"
  end

  # -----------------

  def heading_1() do
    " text-3xl font-bold text-gray-900 mb-4 "
  end

  def heading_2() do
    " text-2xl font-semibold text-gray-900 mb-3 "
  end

  def heading_3() do
    " text-xl font-semibold text-gray-900 mb-1 "
  end

  def paragraph() do
    " text-xl mb-4 leading-relaxed text-left "
  end

  def enhanced_blockquote() do
    " border-l-4 border-gray-300 pl-4 italic bg-blue-50 p-3 rounded-r-lg my-1 "
  end

  def primary_button(size \\ :medium) do
    base =
      " rounded-lg font-semibold transition-all duration-200 hover:bg-gold-cta hover:text-blue-old-glory bg-blue-old-glory text-gold-cta border-2 border-gold-cta "

    case size do
      :small -> base <> " py-1 px-3 text-base "
      :medium -> base <> " py-2 px-4 text-xl "
      :large -> base <> " py-3 px-6 text-2xl "
    end
  end

  def content_card() do
    " bg-white shadow-md rounded-lg p-6 my-6 border-t-4 border-blue-old-glory "
  end

  def footer_icon_button() do
    " cursor-pointer p-2 m-1 text-gray-600 hover:text-blue-old-glory border-2 border-transparent hover:border-2 hover:border-blue-old-glory hover:rounded-lg transition-all duration-200 flex items-center gap-2 "
  end

  # -----------------

  def inline_icon() do
    "cursor-pointer p-1 font-bold text-blue-old-glory hover:text-blue-old-glory border-2 border-white hover:border-2 hover:border-blue-old-glory hover:rounded-xl"
  end

  def footer_icon() do
    "cursor-pointer py-2 px-1 m-2 font-bold text-blue-old-glory hover:text-blue-old-glory border-2 border-white hover:border-2 hover:border-blue-old-glory hover:rounded-xl"
  end

  def radio_button() do
    "cursor-pointer relative size-4 appearance-none rounded-full checked:bg-blue-old-glory text-blue-old-glory border border-gray-500 bg-white before:absolute before:inset-1 before:rounded-full before:bg-white checked:border-blue-old-glory checked:bg-blue-old-glory focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-old-glory disabled:border-gray-300 disabled:bg-gray-100 disabled:before:bg-gray-400 forced-colors:appearance-auto forced-colors:before:hidden [&:not(:checked)]:before:hidden"
  end

  def radio_button_label() do
    "cursor-pointer text-xl pl-4"
  end

  def section_header() do
    " text-left pt-3 mt-4 text-xl font-bold "
  end

  @button_base " rounded-lg py-2 my-2 justify-center text-xl "
  def button_active(full_width? \\ true) do
    @button_base <>
      " border font-semibold hover:bg-gold-cta hover:text-blue-old-glory bg-blue-old-glory text-gold-cta border-gold-cta " <>
      if full_width?, do: " w-full ", else: " "
  end

  def button_inactive(full_width? \\ true) do
    @button_base <>
      " text-xl bg-gray-200 text-gray-500 border-gray-600 " <>
      if full_width?, do: " w-full ", else: " "
  end

  def action_colors(:call_to_action) do
    " bg-blue-900 border-2 text-yellow-400 border-yellow-400 hover:bg-yellow-400 hover:text-blue-900 cursor-pointer "
  end

  def action_colors(:enabled_not_call_to_action) do
    " text-blue-900 border-2 border-gray-200 hover:underline hover:bg-yellow-400 cursor-pointer "
    # " bg-blue-old-glory text-gold-cta border-gold-cta "
  end

  def action_colors(:disabled) do
    " bg-gray-200 text-gray-500 border-2 border-gray-200 cursor-not-allowed "
  end

  def button_style3(button_state)
      when button_state in [:call_to_action, :enabled_not_call_to_action, :disabled] do
    action_colors(button_state) <> " rounded-lg py-2 my-2 justify-center text-xl "
  end

  def button_style(active?, full_width? \\ true) do
    if active?,
      do: button_active(full_width?),
      else: button_inactive(full_width?)
  end

  def button_style2(button_state, full_width? \\ true)

  def button_style2(:call_to_action, full_width?) do
    button_style(true, full_width?)
  end

  def button_style2(:enabled_not_call_to_action, full_width?) do
    button_style(true, full_width?) <> " text-gray-300  bg-[rgb(99,143,190)]"
  end

  def button_style2(:disabled, full_width?) do
    button_style(false, full_width?)
  end

  def step_contents() do
    " flex items-center justify-center text-left min-h-60 sm:min-h-96 h-auto border-2 p-4 my-2 border-gray-400 rounded-lg "
  end

  def step_contents_vertical_border() do
    step_contents_vertical_no_border() <> " border-2 border-gray-400 "
  end

  def step_contents_vertical_no_border() do
    " flex flex-col items-center justify-center text-left min-h-60 sm:min-h-96 h-auto my-2 rounded-lg text-center "
  end

  def welcome_step_contents() do
    " text-left h-auto my-2 rounded-lg text-center "
  end

  def block() do
    " text-left border-2 p-4 my-4 border-gray-400 rounded-lg text-lg"
  end

  def block_no_border() do
    " text-left p-4 my-4 "
  end

  def block_text() do
    " text-xl break-words py-2 "
  end

  def text_fragment() do
    " text-left text-xl break-words py-2 "
  end

  def text_fragment_dialog() do
    text_fragment() <> " m-2 "
  end

  def dialog_div() do
    " transition-all fixed inset-0 z-50 flex items-center rounded-xl justify-center bg-gray-700 bg-opacity-50 overflow-y-auto "
  end

  def instructions(missing_contact_method?) do
    " p-3 m-3 text-md rounded-lg text-left " <>
      if missing_contact_method?,
        do: " bg-orange-100 ",
        else: "  "
  end

  def href() do
    " p-2 " <> href_inline()
  end

  def href_inline() do
    " text-md  text-wrap break-all text-blue-700 hover:underline hover:bg-gray-200 hover:rounded-md "
  end

  def href_smaller() do
    " p-1 text-md  text-wrap break-all text-blue-700 hover:underline hover:bg-gray-200 hover:rounded-md "
  end

  def footer_element() do
    " inline-flex hover:underline hover:bg-gray-300 hover:rounded-md py-1 font-lg text-md text-blue-500 text-wrap break-all "
  end

  def user_info_text_input(has_valid_data?, data_required? \\ true) do
    " mb-3 lg:mb-0 mx-2 ring-0 border-0 border-b-2 placeholder:text-slate-400 placeholder:font-light font-mono text-base rounded-md text-left focus:font-semibold " <>
      if has_valid_data? do
        " text-blue-old-glory bg-gray-100 border-b-blue-old-glory focus:ring-blue-old-glory focus:border-b-blue-old-glory focus:bg-white "
      else
        if data_required?,
          do:
            " text-blue-old-glory bg-amber-50 border-b-gold-input focus:ring-gold-input focus:border-b-gold-input ",
          else:
            " text-[rgb(0, 0, 1)] bg-gray-100 border-b-yellow-300 focus:ring-yellow-300 focus:border-b-yellow-300 focus:bg-white "
      end
  end

  def field_length(min_length, max_length, current_string_content, adjustment \\ 0) do
    actual_length =
      if(current_string_content == nil, do: 0, else: String.length(current_string_content)) +
        adjustment

    cond do
      actual_length < min_length -> min_length
      actual_length > max_length -> max_length
      true -> actual_length
    end
  end

  def textarea(enabled?) do
    " border-2 focus:border-green-500 focus:ring-green-500 focus:ring-2 " <>
      " w-full placeholder:text-slate-400 mt-4 text-base italic rounded-md text-left text-blue-old-glory font-semibold focus:ring-grey-500 focus:border-grey-500 focus:text-xl " <>
      if enabled?, do: " bg-gray-100 border-green-500 ", else: " bg-gray-200 border-gray-300 "
  end
end
