import {
  Table,
  Column,
  Model,
  DataType,
  HasMany,
} from "sequelize-typescript";

import DeliveryOrder from "./deliveryOrder.model";

@Table({
  tableName: "customers",
  timestamps: false,
})
export default class Customer extends Model {

  @Column({
    type: DataType.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  })
  id!: number;

  @Column({
    type: DataType.STRING(150),
    allowNull: true,
  })
  customer_name!: string;

  @Column({
    type: DataType.STRING(20),
    allowNull: true,
  })
  phone?: string;

  @Column({
    type: DataType.STRING(150),
    allowNull: true,
  })
  email?: string;

  @Column({
    type: DataType.TEXT,
    allowNull: true,
  })
  address?: string;

  @Column({
    type: DataType.DECIMAL(10, 7),
    allowNull: true,
  })
  latitude?: number;

  @Column({
    type: DataType.DECIMAL(10, 7),
    allowNull: true,
  })
  longitude?: number;

  @Column({
    type: DataType.DATE,
    defaultValue: DataType.NOW,
  })
  created_at?: Date;

  @HasMany(() => DeliveryOrder, {
    foreignKey: "customer_id",
    as: "orders",
  })
  orders!: DeliveryOrder[];
}