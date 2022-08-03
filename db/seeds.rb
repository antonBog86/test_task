# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:

Operations::Users::Create.call(email: 'test@user.com', password: 'secure_one')
Operations::Users::Create.call(email: 'test_1@user.com', password: 'secure_one')
