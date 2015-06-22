class ProgramEntriesController < ApplicationController

  before_action :authorize_user

  def move_up
    program_entry = ProgramEntry.find(params[:id])
    program = program_entry.program
    authorize_program_owner(program)
    above_entry = program.program_entries.where('"program_entries"."order" < ?', program_entry.order).order(:order).last

    if not above_entry and program_entry.order < 200
      # top entry, and einstieg -> do nothing

    elsif not above_entry and program_entry.order >= 200
      # top entry, but not einstieg -> -100 and move up to next 100er number
      program_entry.order -= 100
      program_entry.order -= (program_entry.order % 100)
      program_entry.save

    elsif (above_entry.order < 200 and (200..299) === program_entry.order) or
       ((200..299) === above_entry.order and program_entry.order >= 300)
      # einstieg and hauptteil, or hauptteil and ausstieg -> move below above
      program_entry.order = above_entry.order + 1
      program_entry.save

    elsif (above_entry.order < 200 and program_entry.order >= 300)
      # top of ausstieg, but no hauptteil -> set as first hauptteil
      program_entry.order = 200
      program_entry.save

    elsif (above_entry.order < 200 and program_entry.order < 200) or
       ((200..299) === above_entry.order and (200..299) === program_entry.order) or
       (above_entry.order >= 300 and program_entry.order >= 300)
      # same block? -> just swap
      above_entry.order,program_entry.order = program_entry.order,above_entry.order
      program_entry.save
      above_entry.save
    end

    redirect_to program
  end

  def move_down

    program_entry = ProgramEntry.find(params[:id])
    program = program_entry.program
    authorize_program_owner(program)
    below_entry = program.program_entries.where('"program_entries"."order" > ?', program_entry.order).order(:order).first

    if not below_entry and program_entry.order >= 300
      # bottom entry, and hauptteil -> do nothing

    elsif not below_entry and program_entry.order < 300
      # bottom entry, but not ausstieg -> move down do next 100-number
      program_entry.order += 100
      program_entry.order -= (program_entry.order % 100)
      program_entry.save

    elsif (program_entry.order < 200 and (200..299) === below_entry.order) or
        ((200..299) === program_entry.order and below_entry.order >= 300)
      # einstieg and hauptteil, or hauptteil and ausstieg -> move above below
      if below_entry.order % 100 == 0
        program_entry.order = below_entry.order
        program.program_entries.where(order: (below_entry.order..(below_entry.order+99))).each do |pe|
          pe.order += 1
          pe.save
        end
      else
        program_entry.order = below_entry.order - 1
      end
      program_entry.save

    elsif (program_entry.order < 200 and below_entry.order >= 300)
      # bottom of einstieg, but no hauptteil -> set as first hauptteil
      program_entry.order = 200
      program_entry.save

    elsif (program_entry.order < 200 and below_entry.order < 200) or
       ((200..299) === program_entry.order and (200..299) === below_entry.order) or
       ((200..299) === program_entry.order >= 300 and below_entry.order >= 300)
      # same block? -> just swap
      below_entry.order,program_entry.order = program_entry.order,below_entry.order
      program_entry.save
      below_entry.save
    end

    redirect_to program
  end

  def destroy
    program_entry = ProgramEntry.find(params[:id])
    program = program_entry.program

    if not program_entry.entry.independent
      program_entry.destroy
    end
    program_entry.destroy

    program = update_program_attributes(program)
    program.save
    
    redirect_to program
  end


  def add_new_entry
    @entry = Entry.new
    program = Program.find(params[:id])

    order = params[:order].to_i
    last_program_entry = ProgramEntry.where(program: program).where(order: (order..(order+99))).order(:order).last
    order = last_program_entry.order+1 if last_program_entry
    @program_entry = ProgramEntry.new(program: program, order: order)

    render 'entries/new'
  end

  def add_existing_entry
    session[:add_ex_entry] = params[:id].to_i
    session[:add_ex_entry_order] = params[:order].to_i
    redirect_to entries_url
  end

  private
    def authorize_program_owner (program)
      raise AuthorizationError unless program_owner?(program)
    end
end