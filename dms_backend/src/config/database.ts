import { Sequelize } from 'sequelize-typescript';
import { env } from './dotenv.config';

// Import all models
import { User } from '../models/user.model'
import { FcmToken } from '../models/fcmToken.model';
import { RefreshToken } from '../models/refreshToken.model';
import { Role } from '../models/role.model';
import DeliveryOrder from '../models/deliveryOrder.model';
import Customer from '../models/customer.model';


export const sequelize = new Sequelize({
  database: env.DB_NAME,
  username: env.DB_USER,
  password: env.DB_PASSWORD,
  host: env.DB_HOST,
  dialect: 'mysql',

  models: [
    User,
    FcmToken,
    RefreshToken,
    Role,
    DeliveryOrder,
    Customer,
    
  ],

  logging: false,

  dialectOptions: {
    multipleStatements: true,
  },
});

export const connectDB = async (): Promise<void> => {
  try {
    await sequelize.authenticate();
    console.log('✅ Database connected successfully');
  } catch (error) {
    console.error('❌ Unable to connect to database:', error);
    throw error;
  }
};