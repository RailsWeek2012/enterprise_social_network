module CompaniesHelper
	def back_to_companies
		link_to "Back", companies_path, class: "btn"
	end

	def company_link(company)
		link_to company.name, company
	end

	def link_edit_company(company)
		if current_user == company.owner
			link_to(content_tag(:i, nil, class: "icon-pencil")+" Edit", edit_company_path(company), class: "btn")
		end
	end
end
