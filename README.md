Harvest
=====

Harvest Time Tracking API Wrapper written in Elixir

## Installation
Add Harvest to your `mix.exs` dependencies:

```elixir
def deps do
  [{:harvest, "~> 0.1"}]
end
```
and run `$ mix deps.get`.

## Configuration

In `config/config.exs`, add your Harvest configurations like [this](config/config.exs.example)

```elixir
config :harvest,
  company: "your_company",
  email: "user@your_company.com",
  password: "user_password",
  has_ssl: true
```

## Usage examples

```elixir
iex(1)> Harvest.get_entries
iex(1)> Harvest.get_entries([user: "174807"])
iex(1)> Harvest.get_entries([user: "174807", year: "2015", day: "272"])
iex(1)> Harvest.get_entry([day_entry_id: "379234955"])
iex(1)> Harvest.get_entry([user: "174807", day_entry_id: "379234955"])
```
