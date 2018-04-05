defmodule TestHelper do
  @phantomjs_path "./assets/node_modules/phantomjs-prebuilt/bin/phantomjs --wd"

  def setup_phantomjs do
    port = Port.open({:spawn, @phantomjs_path}, [:binary])
    {:os_pid, os_pid} = Port.info(port, :os_pid)

    System.at_exit(fn _ ->
      "kill #{os_pid}"
      |> String.to_charlist()
      |> :os.cmd()
    end)

    wait_starting()
  end

  def wait_starting do
    receive do
      {_port, {:data, output}} ->
        if !String.match?(output, ~r/running on port 8910/) do
          IO.puts "Starting PhatomJS failed: #{inspect output}"
          System.halt(1)
        end

      after 1_000 ->
        wait_starting()
    end
  end
end

TestHelper.setup_phantomjs()
Application.ensure_all_started(:hound)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(SampleApp.Repo, :manual)
