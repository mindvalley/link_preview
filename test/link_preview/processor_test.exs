defmodule LinkPreview.ProcessorTest do
  use LinkPreview.Case
  alias LinkPreview.Parsers.{Opengraph, Html}
  use Mimic

  describe "call when url leads to html" do
    setup [:reset_defaults]

    test "ignores missing parsers and returns Page" do
      LinkPreview.Requests
      |> stub(:get, fn _ -> {:ok, %Tesla.Env{status: 200, body: @opengraph}} end)
      |> stub(:get, fn _ ->
        {:ok, %Tesla.Env{status: 200, headers: [{"content-type", "text/html"}]}}
      end)

      Application.put_env(:link_preview, :parsers, [Opengraph, Html, MissingOne])
      assert {:ok, %LinkPreview.Page{}} = LinkPreview.Processor.call(@httparrot <> "/image")
    end
  end

  describe "call when url leads to image" do
    test "returns Page" do
      assert {:ok, %LinkPreview.Page{}} = LinkPreview.Processor.call(@httparrot <> "/image")
    end
  end

  describe "call when url leads to unsupported format" do
    test "returns Error" do
      assert {:error, %LinkPreview.Error{}} =
               LinkPreview.Processor.call(@httparrot <> "/robots.txt")
    end
  end

  describe "call when http client returns error on" do
    test "head" do
      stub(LinkPreview.Requests, :head, fn _ ->
        {:error, %Tesla.Error{reason: "adapter error: :econnrefused"}}
      end)

      Application.put_env(:link_preview, :parsers, [Opengraph, Html, MissingOne])

      assert {:error, %LinkPreview.Error{}} = LinkPreview.Processor.call(@httparrot <> "/image")
    end

    test "get" do
      LinkPreview.Requests
      |> stub(:get, fn _ -> {:error, %Tesla.Error{reason: "adapter error: :econnrefused"}} end)
      |> stub(:head, fn _ ->
        {:ok, %Tesla.Env{status: 200, headers: [{"content-type", "text/html"}]}}
      end)

      Application.put_env(:link_preview, :parsers, [Opengraph, Html, MissingOne])
      assert {:error, %LinkPreview.Error{}} = LinkPreview.Processor.call(@httparrot <> "/image")
    end
  end

  defp reset_defaults(opts) do
    on_exit(fn -> Application.put_env(:link_preview, :parsers, nil) end)
    {:ok, opts}
  end
end
