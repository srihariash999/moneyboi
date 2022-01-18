const { Expense, validate } = require('../models/expense');
const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const _ = require('lodash');

//* Create Expense record api
router.post('/', auth, async (req, res) => {
    const { error } = validate(req.body);
    if (error) return res.status(400).send(error.details[0].message);
    const id = req.user._id;
    let expense = new Expense(
        {
            category: req.body.category,
            user: id,
            amount: req.body.amount,
            record_date: req.body.record_date
        }
    );

    try {
        await expense.save();

        res.send(expense);
    } catch (e) {
        res.status(400).send("Server error", e);
    }
});

router.get('/', auth, async (req, res) => {
    try {
        const id = req.user._id;
        console.log(`id from token : ${id}`);
        if (req.query.date_in != null && req.query.date_out != null) {
            let dateIn = new Date(req.query.date_in).toISOString();
            let dateOut = new Date(req.query.date_out).toISOString();
            let expenses = await Expense.find(
                { user: id, record_date: { $gte: dateIn, $lte: dateOut } }
            );
            return res.send(expenses);
        }

        if (req.query.date_in != null && req.query.date_out == null) {

            let dateIn = new Date(req.query.date_in).toISOString();
            let expenses = await Expense.find(
                {
                    user: id,
                    record_date: { $gte: dateIn }
                }
            );
            return res.send(expenses);
        }
        if (req.query.date_in == null && req.query.date_out != null) {
            let dateOut = new Date(req.query.date_out).toISOString();
            let expenses = await Expense.find(
                {
                    user: id,
                    record_date: { $lte: dateOut }
                }
            );
            return res.send(expenses);
        }

        else {
            //Both Null

            let expenses = await Expense.find(
                { user: id }
            );
            return res.send(expenses);
        }
    } catch (e) {
        console.log(e);
        res.status(500).send("Server error");
    }

});

module.exports = router;
