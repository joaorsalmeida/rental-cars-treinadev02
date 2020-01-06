class Rental < ApplicationRecord
  belongs_to :client
  belongs_to :car_category
  belongs_to :subsidiary
  enum status: { scheduled: 0, in_progress: 5 }
  validates :start_date, presence: { message: 'Data de início não pode ficar em branco' }
  validates :end_date, presence: { message: 'Data de fim não pode ficar em branco' }
  validate :end_date_must_be_greater_than_start_date,
           :start_date_equal_or_greater_than_today
  has_one :car_rental
  has_one :car, through: :car_rental

  def end_date_must_be_greater_than_start_date
    return unless start_date.present? && end_date.present?

    if end_date <= start_date
      errors.add(:end_date, 'deve ser maior que data de início')
    end
  end

  def start_date_equal_or_greater_than_today
    return unless start_date.present?

    if start_date < Date.current
      errors.add(:start_date, 'deve ser maior que a data de hoje.')
    end
  end

  def cars_available?
    #carros disponiveis
    car_models = CarModel.where(car_category: car_category)
    total_cars = Car.where(car_model: car_models).count

    #locacoes agendadas
    total_rentals = Rental.where(car_category: car_category, subsidiary: subsidiary)
                          .where("start_date < ? AND end_date > ?", start_date, start_date)
                          .count
    (total_cars - total_rentals) > 0
  end

end
