require 'rails_helper'

RSpec.describe "patients/show", type: :view do
  let(:dr_role) { Role.create! description: Role::DOCTOR }
  let(:staff_role) { Role.create! description: Role::STAFF }
  let(:staff) { User.create! first_name: SecureRandom.uuid, role_id: staff_role.id }
  let(:doctor) { User.create! first_name: SecureRandom.uuid, role_id: dr_role.id }

  before(:each) do
    @patient = assign(:patient, Patient.create!(
      first_name: "First Name",
      last_name: "Last Name",
      date_of_birth: "10/11/1971",
      state: "OH"
    ))
    @pharmacy = assign(:pharmacy, Pharmacy.create!(
      name: 'CVS',
      street: '123 Easy St.'
    ))
    @prescription = assign(:prescription, Prescription.create!(
      drug_number: '12345',
      drug_name: 'Nexium',
      quantity: '10',
      frequency: 'qD',
      refills: '3',
      dispense_as_written: true,
      formulary_status: 'On Formulary',
      pharmacy_id: @pharmacy.id
    ))
    @patient.prescriptions.push(@prescription)
    @prescriptions = @patient.prescriptions
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/10\/11\/1971/)
    expect(rendered).to match(/OH/)
  end

  context "user is doctor" do
    it "shows the add prescription button" do
      session[:user_id] = doctor.id
      render
      expect(rendered).to match(/Add Prescription/)
    end
  end

  context "user is not a doctor" do
    it "does not show the add prescription button" do
      session[:user_id] = staff.id
      render
      expect(rendered).to_not match(/Add Prescription/)
    end
  end
end
