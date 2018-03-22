defmodule ToyApp.ArticlesTest do
  use ToyApp.DataCase

  alias ToyApp.Articles

  describe "microposts" do
    alias ToyApp.Articles.Micropost

    @valid_attrs %{content: "some content", user_id: 42}
    @update_attrs %{content: "some updated content", user_id: 43}
    @invalid_attrs %{content: nil, user_id: nil}

    def micropost_fixture(attrs \\ %{}) do
      {:ok, micropost} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Articles.create_micropost()

      micropost
    end

    test "list_microposts/0 returns all microposts" do
      micropost = micropost_fixture()
      assert Articles.list_microposts() == [micropost]
    end

    test "get_micropost!/1 returns the micropost with given id" do
      micropost = micropost_fixture()
      assert Articles.get_micropost!(micropost.id) == micropost
    end

    test "create_micropost/1 with valid data creates a micropost" do
      assert {:ok, %Micropost{} = micropost} = Articles.create_micropost(@valid_attrs)
      assert micropost.content == "some content"
      assert micropost.user_id == 42
    end

    test "create_micropost/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Articles.create_micropost(@invalid_attrs)
    end

    test "update_micropost/2 with valid data updates the micropost" do
      micropost = micropost_fixture()
      assert {:ok, micropost} = Articles.update_micropost(micropost, @update_attrs)
      assert %Micropost{} = micropost
      assert micropost.content == "some updated content"
      assert micropost.user_id == 43
    end

    test "update_micropost/2 with invalid data returns error changeset" do
      micropost = micropost_fixture()
      assert {:error, %Ecto.Changeset{}} = Articles.update_micropost(micropost, @invalid_attrs)
      assert micropost == Articles.get_micropost!(micropost.id)
    end

    test "delete_micropost/1 deletes the micropost" do
      micropost = micropost_fixture()
      assert {:ok, %Micropost{}} = Articles.delete_micropost(micropost)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_micropost!(micropost.id) end
    end

    test "change_micropost/1 returns a micropost changeset" do
      micropost = micropost_fixture()
      assert %Ecto.Changeset{} = Articles.change_micropost(micropost)
    end
  end
end
