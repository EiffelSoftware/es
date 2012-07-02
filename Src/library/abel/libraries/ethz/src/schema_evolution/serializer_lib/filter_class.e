note
	description: "Models an abstraction of the filter class, with just the filter class name."
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.2009"

deferred class
	FILTER_CLASS

feature

	filter: STRING 
		-- The filter class name.
	deferred

	ensure
		filter_exists: Result /= Void and then not Result.empty
	end
end
