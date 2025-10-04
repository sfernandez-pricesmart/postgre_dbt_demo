{% macro convert_empty_string_to_null(column_name, data_type='VARCHAR') %}
    CASE 
        WHEN TRIM({{ column_name }}) = '' THEN NULL 
        ELSE {{ column_name }}::{{ data_type }} 
    END
{% endmacro %}
