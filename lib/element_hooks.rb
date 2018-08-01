# frozen_string_literal: true

# This file contains definitions for common hooks used with
# the hookable accessors extension for Page Object
require 'cpt_hook'

# Ensure wait_for_ajax gets called for any function that
# could trigger ajax
WFA_HOOKS ||= CptHook.define_hooks do
  after(:click).call(:wait_for_ajax)
  after(:click!).call(:wait_for_ajax)
  after(:set).call(:wait_for_ajax)
  after(:value=).call(:wait_for_ajax)
  after(:check).call(:wait_for_ajax)
  after(:uncheck).call(:wait_for_ajax)
end

# Make sure the blue event fires after we set masked edits.
MASKED_EDIT_HOOKS ||= CptHook.define_hooks do
  after(:value=).call(:fire_event).with(:blur)
end