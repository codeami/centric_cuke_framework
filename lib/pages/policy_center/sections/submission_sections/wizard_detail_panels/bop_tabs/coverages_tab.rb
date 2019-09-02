
class BusinessownersLineIncludedCoveragesTab < PageObject::GWFormSet

  def initialize(element)
    super(element, { class: 'x-field', visible: true }, 'Included Coverages' )
  end

end