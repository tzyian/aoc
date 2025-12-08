defmodule UnionFind do
  defstruct parents: %{}, sizes: %{}
  @type t :: %UnionFind{}

  @doc """
  Create a new Union-Find data structure
  """
  @spec new() :: UnionFind.t()
  def new, do: %UnionFind{}

  @doc """
  Find with path compression
  """
  @spec find(UnionFind.t(), integer()) :: {integer(), UnionFind.t()}
  def find(%UnionFind{} = state, x) do
    state =
      if Map.has_key?(state.parents, x) do
        state
      else
        %{
          state
          | parents: Map.put(state.parents, x, x),
            sizes: Map.put(state.sizes, x, 1)
        }
      end

    case Map.get(state.parents, x) do
      ^x ->
        {x, state}

      parent ->
        {root, updated_state} = find(state, parent)
        new_parents = Map.put(updated_state.parents, x, root)
        {root, %{updated_state | parents: new_parents}}
    end
  end

  @doc """
  Union by size
  """
  @spec union(UnionFind.t(), integer(), integer()) :: UnionFind.t()
  def union(%UnionFind{} = state, x, y) do
    {root_x, s1} = find(state, x)
    {root_y, s2} = find(s1, y)

    if root_x == root_y do
      s2
    else
      size_x = UnionFind.get_size(s2, root_x)
      size_y = UnionFind.get_size(s2, root_y)

      if size_x < size_y do
        link(s2, root_x, root_y, size_x, size_y)
      else
        link(s2, root_y, root_x, size_y, size_x)
      end
    end
  end

  defp link(%UnionFind{} = state, child, parent, child_size, parent_size) do
    %{
      state
      | parents: Map.put(state.parents, child, parent),
        sizes: Map.put(state.sizes, parent, parent_size + child_size)
    }
  end

  @spec get_roots(UnionFind.t()) :: list(integer())
  def get_roots(%UnionFind{} = state) do
    state.parents
    |> Enum.filter(fn {node, parent} -> node == parent end)
    |> Enum.map(fn {root, _} -> root end)
  end

  @spec get_size(UnionFind.t(), integer()) :: integer()
  def get_size(%UnionFind{} = state, x) do
    {root, _} = find(state, x)
    Map.get(state.sizes, root)
  end
end
