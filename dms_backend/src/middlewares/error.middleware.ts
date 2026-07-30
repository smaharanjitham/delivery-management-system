import { Request, Response, NextFunction } from 'express';
import multer from 'multer';

export const errorHandler = (
    err: any,
    req: Request,
    res: Response,
    next: NextFunction
) => {
    console.error(err);

    if (err instanceof multer.MulterError) {
        return res.status(400).json({
            success: false,
            message: err.message,
        });
    }

    if (err.name === 'ValidateError') {
        return res.status(422).json({
            success: false,
            message: 'Validation Failed',
            details: err.fields,
        });
    }

    if (err.status) {
        return res.status(err.status).json({
            success: false,
            message: err.message,
        });
    }

    return res.status(500).json({
        success: false,
        message: err.message || 'Internal Server Error',
    });
};