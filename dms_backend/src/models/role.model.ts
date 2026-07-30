import {
  Table,
  Column,
  Model,
  DataType,
  HasMany,
} from 'sequelize-typescript';

import { User } from './user.model';

@Table({
  tableName: 'roles',
  timestamps: false,
})
export class Role extends Model {
  @Column({
    type: DataType.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  })
  id!: number;

  @Column({
    type: DataType.STRING(50),
    allowNull: false,
    unique: true,
  })
  role_name!: string;

  @Column({
    type: DataType.DATE,
    defaultValue: DataType.NOW,
  })
  created_at?: Date;

  @HasMany(() => User, {
    foreignKey: 'role_id',
    as: 'users',
  })
  users!: User[];
}