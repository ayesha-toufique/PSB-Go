const { body } = require('express-validator');

const registerValidation = [
  body('name').trim().isLength({ min: 2, max: 80 }).withMessage('Name must be 2 to 80 characters.'),
  body('email').trim().isEmail().withMessage('Enter a valid email address.'),
  body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters.'),
  body('role').optional().isIn(['passenger', 'driver']).withMessage('Role must be passenger or driver.'),
  body('cnic')
  .if((value, { req }) => req.body.role === 'driver')
  .matches(/^\d{5}-?\d{7}-?\d{1}$/)
  .withMessage('Enter a valid 13-digit CNIC.'),
  body('licenseNo').if((value, { req }) => req.body.role === 'driver').trim().notEmpty().withMessage('Driving licence number is required.')
];

const loginValidation = [
  body('email').trim().isEmail().withMessage('Enter a valid email address.'),
  body('password').notEmpty().withMessage('Password is required.')
];

module.exports = { registerValidation, loginValidation };
