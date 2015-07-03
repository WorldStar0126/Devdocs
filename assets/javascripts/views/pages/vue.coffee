#= require views/pages/base

class app.views.VuePage extends app.views.BasePage
  afterRender: ->
    for el in @findAllByTag('pre')
      lang = if el.classList.contains('html') or el.textContent[0] is '<'
        'markup'
      else if el.classList.contains('css')
        'css'
      else
        'javascript'
      el.setAttribute('class', '')
      @highlightCode el, lang
    return
