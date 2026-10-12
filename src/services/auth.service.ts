import bcrypt from 'bcrypt';
import { userRepository } from '../repositories/user.repository';
import { AppError } from '../utils/AppError';
import { signToken } from '../utils/jwt';
import { sanitizeUser } from '../utils/sanitizeUser';
import { LoginInput, UpdatePasswordInput, UpdateProfileInput } from '../validations/auth.validation';

const SALT_ROUNDS = 10;

export const authService = {
  async login(input: LoginInput) {
    const user = await userRepository.findByEmail(input.email);
    if (!user) {
      throw new AppError('Invalid email or password', 401);
    }

    const isValidPassword = await bcrypt.compare(input.password, user.password);
    if (!isValidPassword) {
      throw new AppError('Invalid email or password', 401);
    }

    if (!user.is_active) {
      throw new AppError('Your account has been deactivated', 401);
    }

    const token = signToken({ userId: user.id, role: user.role });
    return { user: sanitizeUser(user), token };
  },

  async updateProfile(id: string, input: UpdateProfileInput) {
    const updated = await userRepository.update(id, input);
    return sanitizeUser(updated);
  },

  async updatePassword(id: string, input: UpdatePasswordInput) {
    const user = await userRepository.findById(id);
    if (!user) {
      throw new AppError('User not found', 404);
    }

    const isValidPassword = await bcrypt.compare(input.currentPassword, user.password);
    if (!isValidPassword) {
      throw new AppError('Current password is incorrect', 400);
    }

    if (input.newPassword === input.currentPassword) {
      throw new AppError('New password must be different from the current password', 400);
    }

    const hashedPassword = await bcrypt.hash(input.newPassword, SALT_ROUNDS);
    await userRepository.update(id, { password: hashedPassword });
  },
};
