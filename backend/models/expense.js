const Joi = require('joi');
const mongoose = require('mongoose');

const expenseSchema = new mongoose.Schema(
    {
        category: {
            type: String,
            required: true,
            minlength: 3,
            maxlength: 255
        },
        amount: {
            type: Number,
            required: true,
            min: 0,
            
        },
        user: {
            type: String,
            required: true,
        },
        record_date: {
            type: Date,
            required : true,
            default: Date.now,
        },
        
    }
);

const Expense = mongoose.model('Expense', expenseSchema);

function validateExpense(expense) {
    const schema = Joi.object({
        category: Joi.string().min(3).max(255).required(),
        amount: Joi.number().min(0).required(),
        record_date: Joi.date().required(),
    });

    return schema.validate(expense);
}

exports.Expense = Expense;
exports.validate = validateExpense;