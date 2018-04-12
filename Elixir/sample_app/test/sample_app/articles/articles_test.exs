defmodule SampleApp.ArticlesTest do
  use SampleApp.DataCase

  alias SampleApp.Accounts
  alias SampleApp.Accounts.User
  alias SampleApp.Articles
  alias SampleApp.Articles.Micropost

  setup do
    {:ok, user} = Accounts.create_user(%{
                    name: "foo",
                    email: "foo@example.com",
                    password: "password",
                    password_confirmation: "password"
                  })
    [user: user]
  end

  describe "microposts" do

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil, user_id: nil}

    def micropost_fixture(user, attrs \\ %{}) do
      {:ok, micropost} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Articles.create_micropost(user)

      micropost
    end

    test "list_microposts/0 returns all microposts", %{user: user} do
      micropost = micropost_fixture(user)
      assert Articles.list_microposts() == [micropost]
    end

    test "get_micropost!/1 returns the micropost with given id", %{user: user} do
      micropost = micropost_fixture(user)
      assert Articles.get_micropost!(micropost.id) == micropost
    end

    test "create_micropost/1 with valid data creates a micropost", %{user: user} do
      assert {:ok, %Micropost{} = micropost} = Articles.create_micropost(@valid_attrs, user)
      assert micropost.content == "some content"
      assert micropost.user_id == user.id
    end

    test "create_micropost/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Articles.create_micropost(@invalid_attrs, user)
    end

    test "update_micropost/2 with valid data updates the micropost", %{user: user} do
      micropost = micropost_fixture(user)
      assert {:ok, micropost} = Articles.update_micropost(micropost, @update_attrs)
      assert %Micropost{} = micropost
      assert micropost.content == "some updated content"
      assert micropost.user_id == user.id
    end

    test "update_micropost/2 with invalid data returns error changeset", %{user: user} do
      micropost = micropost_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Articles.update_micropost(micropost, @invalid_attrs)
      assert micropost == Articles.get_micropost!(micropost.id)
    end

    test "delete_micropost/1 deletes the micropost", %{user: user} do
      micropost = micropost_fixture(user)
      assert {:ok, %Micropost{}} = Articles.delete_micropost(micropost)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_micropost!(micropost.id) end
    end

    test "change_micropost/1 returns a micropost changeset", %{user: user} do
      micropost = micropost_fixture(user)
      assert %Ecto.Changeset{} = Articles.change_micropost(micropost)
    end
  end

  describe "validation" do
    test "content should be present", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Articles.create_micropost(%{}, user)
    end

    test "content should be at most 140 characters", %{user: user} do
      content = String.duplicate("a", 141)
      assert {:error, %Ecto.Changeset{}} = Articles.create_micropost(%{content: content}, user)
    end
  end

  describe "delete" do
    test "associated microposts should be deleted", %{user: user} do
      assert {:ok, %Micropost{}} = Articles.create_micropost(@valid_attrs, user)
      before_count = Repo.aggregate(Micropost, :count, :id)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      after_count = Repo.aggregate(Micropost, :count, :id)
      assert before_count - after_count == 1
    end
  end
end
