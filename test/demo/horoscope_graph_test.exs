defmodule Demo.HoroscopeGraphTest do
  use Demo.DataCase

  alias Demo.HoroscopeGraph

  describe "testing graph behavior" do
    test "Bowser is blocked from the system" do
      execution =
        HoroscopeGraph.graph()
        |> Journey.start_execution()
        |> Journey.set_value(:name, "Bowser")

      # Wait for the computation to complete and check the result
      assert Journey.get_value(execution, :name_validation, wait_new: true) ==
               {:ok, "no horoscope for Bowser!"}
    end
  end

  describe "testing 'business logic'" do
    test "compute_zodiac_sign/1" do
      assert {:ok, "Capricorn"} =
               HoroscopeGraph.compute_zodiac_sign(%{birth_month: "January", birth_day: 1})

      assert {:ok, "Aquarius"} =
               HoroscopeGraph.compute_zodiac_sign(%{birth_month: "January", birth_day: 20})

      assert {:ok, "Pisces"} =
               HoroscopeGraph.compute_zodiac_sign(%{birth_month: "February", birth_day: 19})

      assert {:ok, "Pisces"} =
               HoroscopeGraph.compute_zodiac_sign(%{birth_month: "February", birth_day: 20})

      assert {:ok, "Pisces"} =
               HoroscopeGraph.compute_zodiac_sign(%{birth_month: "March", birth_day: 20})

      assert {:ok, "Aries"} =
               HoroscopeGraph.compute_zodiac_sign(%{birth_month: "March", birth_day: 21})

      assert {:ok, "Taurus"} =
               HoroscopeGraph.compute_zodiac_sign(%{birth_month: "April", birth_day: 24})
    end
  end
end
