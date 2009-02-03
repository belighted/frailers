module ApplicationHelper

  def tab(name, controllers, options)
    if controllers.include?(controller.controller_name)
      "<li class='active'>" + name + "</li>"
    else
      "<li>" + link_to(name, options) + "</li>"
    end
  end

  def error_for(object, method = nil, options={})
    if method
      err = instance_variable_get("@#{object}").errors.on(method).to_sentence rescue instance_variable_get("@#{object}").errors.on(method)
    else
      err = @errors["#{object}"] rescue nil
    end
    err || ""
  end

  def render_partial_if_exists(path)
    render(:partial => path) rescue nil
  end

  def partial_template_exists?(path)
    erb_template_exists?(partial_pieces(path).join('/_'))
  end

  def ultraviolet(input, format="ruby_on_rails", theme="blackboard")
   Uv.parse(input, "xhtml", format, true, theme)
  end

  def pagination(collection)
    if collection.total_entries > 1
      "<p class='pages'>" + 'Pages' + ": <strong>" + 
      (will_paginate(collection, :inner_window => 10, :next_label => "suivant", :prev_label => "précédent") || "") +
      "</strong></p>"
    end
  end

  def next_page(collection)
    unless collection.current_page == collection.page_count or collection.page_count == 0
      "<p style='float:right;'>" + link_to("Next page", { :page => collection.current_page.next }.merge(params.reject{|k,v| k=="page"})) + "</p>"
    end
  end

  def thumbnail_for(thing, format=:thumb75)
    return image_tag(thing.picture.url(format))
  end

end