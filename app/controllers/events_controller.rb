class EventsController < ApplicationController
  before_action :authorize
  before_action :fetch_event, except: [:create, :index]

  def index
    events = @current_user.events
    render json: { errors: { messgae: "No events are present for current user"}}, status: :not_found and return unless events.any?
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(events, each_serializer: EventsSerializer),
      messgae: "Events fetched successfully"
    }, status: :ok
  end

  def create
    event = @current_user.events.create(event_params)
    if event.persisted?
      render json: {
        data: ActiveModelSerializers::SerializableResource.new(event, each_serializer: EventsSerializer),
        messgae: "Event created successfully"
      }, status: :created
    else
      render json: { errors: { messgae: "Something went wrong" } }, status: 422
    end
  end

  def show
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@event, each_serializer: EventsSerializer),
      messgae: "Event fetched successfully."
    }, status: 200
  end

  def update
    if @event.update(update_params)
      render json: {
        data: ActiveModelSerializers::SerializableResource.new(@event, each_serializer: EventsSerializer),
        messgae: "Event updated successfully."
       }, status: 200
    else
      render json: { errors: { messgae: "Something went wrong"}}, status: 422
    end
  end

  def destroy
    @event.destroy
    render json: { messgae: "Event deleted successfully"}, status: 202
  end

  private

  def fetch_event
    @event = @current_user.events.find_by_id(params[:id])
    render json: { errors: { messgae: "No event found with #{params[:id]}"}}, status: :not_found and return unless @event.present?
  end

  def event_params
    params.require(:event).permit(:title, :description, :status)
  end

  def update_params
    params.permit(:status, :title, :description)
  end
end
