let g:rails_gem_projections = {
      \  "pundit": {
      \    "app/policies/*_policy.rb": {
      \      "command": "policy",
      \      "affinity": "model",
      \      "template": "class %SPolicy < ApplicationPolicy\nend"
      \    }
      \  },
      \  "factory_girl_rails": {
      \    "spec/factories/*.rb": {
      \      "command": "factory",
      \      "affinity": "model",
      \      "template": "FactoryGirl.define do\n  factory :%s do\n  end\nend"
      \    }
      \  },
      \  "reform": {
      \    "app/forms/*_form.rb": {
      \      "command": "form",
      \      "affinity": "controller",
      \      "template": "class %SForm < Reform::Form\n  end"
      \    }
      \  },
      \  "cells": {
      \    "app/cells/*_cell.rb": {
      \      "command": "cell",
      \      "affinity": "controller",
      \      "template": "class %sCell < Cell::ViewModel\n  \nend"
      \    }
      \  }
      \}
