module Amatista
  #Flash sessions used until it is called.
  module Flash
    def set_flash(key, value)
      $amatista.flash[key] = value
    end

    def get_flash(key)
      tmp = $amatista.flash[key]?
      $amatista.flash.delete(key)
      tmp
    end
  end
end
