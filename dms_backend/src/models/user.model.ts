import {
  Table,
  Column,
  Model,
  DataType,
  ForeignKey,
  BelongsTo,
  HasMany,
} from 'sequelize-typescript';

import { Role } from './role.model';
import FcmToken from './fcmToken.model';
import { RefreshToken } from './refreshToken.model';

@Table({
  tableName: 'users',
  timestamps: false,
})
export class User extends Model {
  @Column({
    type: DataType.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  })
  id!: number;

  @ForeignKey(() => Role)
  @Column({
    type: DataType.INTEGER,
    allowNull: false,
    references: {
      model: 'roles',
      key: 'id',
    },
  })
  role_id!: number;

  @Column({
    type: DataType.STRING(150),
    allowNull: false,
  })
  full_name!: string;

  @Column({
    type: DataType.STRING(150),
    allowNull: false,
    unique: true,
  })
  email!: string;

  @Column({
    type: DataType.STRING(20),
    allowNull: true,
  })
  phone?: string;

  @Column({
    type: DataType.STRING(255),
    allowNull: false,
  })
  password!: string;

  @Column({
    type: DataType.STRING(255),
    allowNull: true,
  })
  profile_image?: string;

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
    type: DataType.BOOLEAN,
    defaultValue: true,
  })
  is_active!: boolean;

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

  @BelongsTo(() => Role, {
    foreignKey: 'role_id',
    as: 'role',
  })
  role!: Role;

  @HasMany(() => FcmToken, {
    foreignKey: 'user_id',
    as: 'fcmTokens',
  })
  fcmTokens!: FcmToken[];
  @HasMany(() => RefreshToken, {
  foreignKey: 'user_id',
  as: 'refreshTokens',
})
refreshTokens!: RefreshToken[];
}