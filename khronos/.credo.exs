%{
  configs: [
    %{
      name: "default",
      checks: %{
        disabled: [
          # this means that `TabsOrSpaces` will not run
          {Credo.Check.Readability.ModuleDoc, []}
        ],
        enabled: [
          {Credo.Check.Refactor.Nesting, [max_nesting: 3]}
        ]
      }
      # files etc.
    }
  ]
}
