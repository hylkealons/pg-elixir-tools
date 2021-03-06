defmodule ElixirTools.RollbaxFake do
  @spec report_message(:critical | :error | :warning | :info | :debug, IO.chardata(), map, map) ::
          :ok
  def report_message(level, message, custom \\ %{}, occurrence_data \\ %{}) do
    ensure_no_struct(custom)
    ensure_no_struct(occurrence_data)
    send(self(), [:rollbax_message, level, message, custom, occurrence_data])
  end

  @spec report(:error | :exit | :throw, any, [any], map, map) :: :ok
  def report(kind, value, stacktrace, custom \\ %{}, occurrence_data \\ %{}) do
    ensure_no_struct(custom)
    ensure_no_struct(occurrence_data)
    send(self(), [:rollbax_report, kind, value, stacktrace, custom, occurrence_data])
  end

  @spec ensure_no_struct(any) :: no_return() | :ok
  defp ensure_no_struct(map) when is_struct(map) do
    raise "Rollbax does not know how to handle structs and will raise an error. Convert it to a map."
  end

  defp ensure_no_struct(map) when is_map(map) do
    for {_k, v} <- map, do: ensure_no_struct(v)
  end

  defp ensure_no_struct(_), do: :ok
end
