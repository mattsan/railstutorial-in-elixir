defmodule SampleApp.AccountsTest do
  use SampleApp.DataCase

  alias SampleApp.{Accounts, Repo}
  alias SampleApp.Accounts.User

  import SampleAppWeb.TestHelper

  describe "users" do
    @valid_attrs %{email: "some.email@example.com", name: "some name", password: "some password", password_confirmation: "some password"}
    @update_attrs %{email: "some.updated.email@example.com", name: "some updated name", password: "some updated password", password_confirmation: "some updated password"}
    @invalid_attrs %{email: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Enum.map(Accounts.list_users(), &Map.take(&1, [:id, :name, :email])) == [Map.take(user, [:id, :name, :email])]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Map.take(Accounts.get_user!(user.id), [:id, :name, :email]) == Map.take(user, [:id, :name, :email])
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some.email@example.com"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some.updated.email@example.com"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert Map.take(user, [:id, :name, :email]) == Map.take(Accounts.get_user!(user.id), [:id, :name, :email])
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "users validation" do
    setup context do
      name = Map.get(context, :name, "Example User")
      email = Map.get(context, :email, "user@example.com")
      password = Map.get(context, :password, "password")
      password_confirmation = Map.get(context, :password_confirmation, password)

      changeset = User.changeset(%User{}, %{name: name, email: email, password: password, password_confirmation: password_confirmation})
      [changeset: changeset]
    end

    test "should be valid", %{changeset: changeset} do
      assert changeset.valid?
    end

    @tag name: "   "
    test "name should be present", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag email: "    "
    test "email should be present", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag name: String.duplicate("a", 51)
    test "name should not be too long", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag email: String.pad_leading("@example.com", 256, "a")
    test "email should not be too long", %{changeset: changeset} do
      refute changeset.valid?
    end

    ~w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    |> Enum.each(fn email ->
      @tag email: email
      test "#{email} should accept valid address", %{changeset: changeset} do
        assert changeset.valid?
      end
    end)

    ~w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    |> Enum.each(fn email ->
      @tag email: email
      test "#{email} should reject invalid address", %{changeset: changeset} do
        refute changeset.valid?
      end
    end)

    test "email addresses should be unique", %{changeset: changeset} do
      changeset
      |> Repo.insert()

      {:error, duplicate_changeset} =
        User.changeset(%User{}, %{changeset.changes | name: "bar", email: String.upcase(changeset.changes.email)})
        |> Repo.insert()

      refute duplicate_changeset.valid?
    end

    @tag email: "Foo@ExAMPle.CoM"
    test "email addresses should be saved as lower-case", %{changeset: changeset} do
      assert changeset.changes.email == "foo@example.com"
    end

    @tag password: String.duplicate(" ", 6)
    test "password should be present (nonblank)", %{changeset: changeset} do
      refute changeset.valid?
    end

    @tag password: String.duplicate("a", 5)
    test "password should have a minimum length", %{changeset: changeset} do
      refute changeset.valid?
    end
  end

  describe "authenticated?" do
    setup do
      [user: create_user(:example)]
    end

    test "authenticated? should return false for a user with nil digest", %{user: user} do
      refute Accounts.authenticated?(user, "")
    end
  end
end
