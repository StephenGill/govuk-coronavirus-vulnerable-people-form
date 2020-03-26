# frozen_string_literal: true

class CoronavirusForm::BasicCareNeedsController < ApplicationController
  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    basic_care_needs = sanitize(params[:basic_care_needs]).presence
    session[:basic_care_needs] = basic_care_needs

    invalid_fields = validate_radio_field(
      PAGE,
      radio: basic_care_needs,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session[:check_answers_seen]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "basic_care_needs"
  NEXT_PAGE = "dietary_requirements"

  def previous_path
    essential_supplies_path
  end
end
