defmodule IndiClient.Protocol.SaxEventHandler do
  @moduledoc false

  def handle_event(:start_document, _prolog, state) do
    {:ok, {[], state}}
  end

  def handle_event(:end_document, _data, {[], state}) do
    {:ok, state}
  end

  # Outer Element
  def handle_event(:start_element, {tag_name, attributes}, {[], state}) do
    attributes = Map.new(attributes)
    expected = Map.put_new(state, attributes["device"], %{attributes["name"] => %{}})
    {:ok, {[{tag_name, attributes, ""}], expected}}
  end

  # Inner element
  def handle_event(:start_element, {tag_name, attributes}, {stack = [{_parent_tag_name, parent_attributes, _parent_content}], state}) do
    attributes = Map.new(attributes)
    tag_modified = String.replace_prefix(tag_name, "one", "def")
    update = Map.put_new(state[parent_attributes["device"]][parent_attributes["name"]], tag_modified, %{})
    state = put_in(state, [parent_attributes["device"], parent_attributes["name"]], update)
    update = Map.put_new(state[parent_attributes["device"]][parent_attributes["name"]][tag_modified], attributes["name"], %{})
    state = put_in(state, [parent_attributes["device"], parent_attributes["name"], tag_modified], update)

    {:ok, {[{tag_name, attributes, ""} | stack], state}}
  end

  # Outer Element
  def handle_event(:end_element, tag_name, {[{tag_name, attributes, _content}], state}) do
    prev_attributes = get_in(state, [attributes["device"], attributes["name"]])
    state = put_in(state, [attributes["device"], attributes["name"]], Map.merge(prev_attributes, attributes))
    {:ok, {[], state}}
  end

  # Inner element
  def handle_event(:end_element, tag_name, {[{tag_name, attributes, content}, {parent_tag_name, parent_attributes, parent_content}], state}) do
    attributes = Map.put(attributes, "value", String.trim(content))
    tag_modified = String.replace_prefix(tag_name, "one", "def")
    prev_attributes = get_in(state, [parent_attributes["device"], parent_attributes["name"], tag_modified, attributes["name"]])
    state = put_in(state, [parent_attributes["device"], parent_attributes["name"], tag_modified, attributes["name"]], Map.merge(prev_attributes, attributes))
    {:ok, {[{parent_tag_name, parent_attributes, parent_content}], state}}
  end

  def handle_event(:characters, chars, {[{tag_name, attributes, content} | rest], state}) do
    {:ok, {[{tag_name, attributes, content <> chars} | rest], state}}
  end

  def handle_event(:cdata, cdata, {[{tag_name, attributes, content} | rest], state}) do
    {:ok, {[{tag_name, attributes, content <> cdata} | rest], state}}
  end
end
