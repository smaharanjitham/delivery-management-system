import {
  Table,
  Column,
  Model,
  DataType,
  ForeignKey,
  BelongsTo,
} from "sequelize-typescript";

import Customer from "./customer.model";
import { User } from "./user.model";

@Table({
  tableName: "delivery_orders",
  timestamps: false,
})
export default class DeliveryOrder extends Model {

  @Column({
    type: DataType.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  })
  id!: number;

  @Column({
    type: DataType.STRING(50),
    unique: true,
  })
  order_number!: string;

  @ForeignKey(() => Customer)
  @Column(DataType.INTEGER)
  customer_id!: number;

  @ForeignKey(() => User)
  @Column(DataType.INTEGER)
  assigned_to?: number;

  @ForeignKey(() => User)
  @Column(DataType.INTEGER)
  created_by?: number;

  @Column(DataType.TEXT)
  pickup_address?: string;

  @Column(DataType.DECIMAL(10, 7))
  pickup_latitude?: number;

  @Column(DataType.DECIMAL(10, 7))
  pickup_longitude?: number;

  @Column(DataType.TEXT)
  delivery_address?: string;

  @Column(DataType.DECIMAL(10, 7))
  delivery_latitude?: number;

  @Column(DataType.DECIMAL(10, 7))
  delivery_longitude?: number;

  @Column(DataType.STRING(150))
  package_name?: string;

  @Column(DataType.DECIMAL(10, 2))
  package_weight?: number;

  @Column(DataType.DECIMAL(10, 2))
  delivery_fee?: number;

  @Column(DataType.ENUM("Cash", "Card", "Online"))
  payment_mode?: string;

  @Column(DataType.ENUM("Pending", "Paid"))
  payment_status?: string;

  @Column({
    type: DataType.ENUM(
      "Pending",
      "Assigned",
      "Picked Up",
      "Out For Delivery",
      "Delivered",
      "Cancelled",
      "Failed"
    ),
    defaultValue: "Pending",
  })
  status!: string;

  @Column(DataType.DATE)
  expected_delivery?: Date;

  @Column(DataType.DATE)
  delivered_at?: Date;

  @Column({
    type: DataType.DATE,
    defaultValue: DataType.NOW,
  })
  created_at?: Date;

  @Column({
    type: DataType.DATE,
    defaultValue: DataType.NOW,
  })
  updated_at?: Date;

  @BelongsTo(() => Customer, {
    foreignKey: "customer_id",
    as: "customer",
  })
  customer!: Customer;

  @BelongsTo(() => User, {
    foreignKey: "assigned_to",
    as: "deliveryBoy",
  })
  deliveryBoy!: User;

  @BelongsTo(() => User, {
    foreignKey: "created_by",
    as: "createdBy",
  })
  createdBy!: User;
}