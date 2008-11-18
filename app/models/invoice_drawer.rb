class InvoiceDrawer
 	include ActionView::Helpers::NumberHelper	
	def self.draw(invoice)
	  new.draw(invoice)
	end
	
	def draw(invoice)
		pdf = PDF::Writer.new
		pdf.select_font("Times-Roman")

		pdf.y = pdf.in2pts(2.25)
		pdf.text "make check payable to: micah geisel"
		pdf.text "sincerely,"
		
		sign_height = pdf.y
		pdf.add_image_from_file "#{RAILS_ROOT}/public/images/pdf/micah_signature.png", pdf.in2pts(1), pdf.y-pdf.in2pts(1), pdf.in2pts(3), pdf.in2pts(1)
		pdf.y = pdf.y - pdf.in2pts(1)

		pdf.text "micah geisel", :left => pdf.in2pts(1)
		
		pdf.y = sign_height
		pdf.add_image_from_file "#{RAILS_ROOT}/public/images/pdf/michael_signature.png", pdf.in2pts(4), pdf.y- pdf.in2pts(1), pdf.in2pts(3), pdf.in2pts(1)
		pdf.y = pdf.y - pdf.in2pts(1)

		pdf.text "michael gubitosa", :left => pdf.in2pts(5)
	
		pdf.add_image_from_file "#{RAILS_ROOT}/public/images/pdf/fleur.png", pdf.in2pts(5), pdf.in2pts(9), pdf.in2pts(3), pdf.in2pts(1.5)
		
		pdf.y = pdf.in2pts(10.4)
		pdf.text "Bot & Rose Designs 625 NW Everett Street Portland, OR  97209 \0\0\0\0\0", :left => pdf.in2pts(4), :right => pdf.in2pts(2.25), :justification => :full
		
		pdf.add_image_from_file "#{RAILS_ROOT}/public/images/pdf/invoice_header.png", pdf.in2pts(0.5), pdf.in2pts(9.6), pdf.in2pts(3), pdf.in2pts(0.8)
		
		pdf.y = pdf.in2pts(9)
		pdf.text "attention:"
		pdf.text invoice.client.contact, :font_size => 16
		pdf.text invoice.client.address, :font_size => 12
		pdf.text "#{invoice.client.city}, #{invoice.client.state}  #{invoice.client.zip}"

		pdf.y = pdf.in2pts(8)
		pdf.text "Date  .  #{invoice.date.day}  #{Date::MONTHNAMES[invoice.date.month]}  #{invoice.date.year}", :font_size => 14
		
		pdf.y = pdf.in2pts(9)
		
		PDF::SimpleTable.new do |tab|
			tab.maximum_width = 5
			tab.column_order.push(*%w(left middle right))

			tab.shade_rows		= :none
			tab.show_lines    = :none
			tab.show_headings = false
			tab.orientation   = :left
			tab.position      = :right

			tab.columns[:right] = PDF::SimpleTable::Column.new("right") { |col|
				col.justification = :right
			}
			
			data = [
				{
					"left" => "PROJECT",
					"middle" => ".",
					"right" => invoice.project_name
				},
				{
					"left" => "INVOICE NUMBER",
					"middle" => ".",
					"right" => invoice.id
				},
				{
					"left" => "TERMS",
					"middle" => ".",
					"right" => "Due on Receipt"
				},
			]
			
			tab.data.replace data
			tab.render_on(pdf)
		end
		
		pdf.y = pdf.in2pts(7.5)
		
		PDF::SimpleTable.new do |tab|
			#tab.title = "PDF User Unit Conversions"
			tab.maximum_width = 6
			tab.column_order.push(*%w(Agent Item Hours Rate Cost))
			tab.columns[:Agent] = PDF::SimpleTable::Column.new("Agent") { |col|
				col.heading = PDF::SimpleTable::Column::Heading.new("Agent")
				col.heading.bold = true
				col.justification = :center
			}
			tab.columns[:Item] = PDF::SimpleTable::Column.new("Item") { |col|
				col.justification = 'left'
				col.width = 6
			}
			tab.columns[:Hours] = PDF::SimpleTable::Column.new("Hours") { |col|
				col.heading = PDF::SimpleTable::Column::Heading.new("Hours")
				col.heading.bold = true
				col.justification = :center
			}
			tab.columns[:Rate] = PDF::SimpleTable::Column.new("Rate") { |col|
				col.heading = "Rate"
			}
			tab.columns[:cost] = PDF::SimpleTable::Column.new("Cost") { |col|
				col.heading = "Cost"
			}

			tab.shade_rows		= :none
			tab.show_lines    = :none
			tab.show_headings = true
			tab.orientation   = :center
			tab.position      = :center
			tab.row_gap				= pdf.in2pts(0.1)
			
			data = []
			for work in invoice.works
				data << {
					"Agent" => work.user.login,
					"Item" => work.notes.word_wrap(60),
					"Hours" => work.hours.round(2),
					"Rate" => number_to_currency(work.rate),
					"Cost" => number_to_currency(work.total)
				}
			end

			for adjustment in invoice.adjustments
				data << {
					"Item" => 'Adjustment ' + (adjustment.notes ? adjustment.notes.word_wrap(60) : ''),
					"Cost" => number_to_currency(adjustment.total)
				}
			end
			
			data << {
				"Item" => "Total",
				"Cost" => number_to_currency(invoice.total)
			}
			
			tab.data.replace data
			tab.render_on(pdf)
		end
		
		pdf.render
	end
end
